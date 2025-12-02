import {
    RpcProvider,
    PaymasterRpc,
    hash,
    CallData,
    CairoOption,
    CairoOptionVariant,
    CairoCustomEnum,
    Account
} from "starknet";

import { RawSigner } from "./utils/rawSigner";
import { privyRawSign } from "./privyRawSign";

import { RPC_URL, ARGENT_ACCOUNT_CLASS_HASH, AVNU_PAYMASTER_API, PAYMASTER_RPC, SPONSOR_WITH_PAY_MASTER } from "./config";

import { getWalletById } from "./getWalletById";

async function deployArgenXAccount(walletId) {

    try {
        // connect RPC url provider
        const provider = new RpcProvider({
            nodeUrl: RPC_URL
        });

        // Get wallet details via wallet id
        const wallet_details = await getWalletById(walletId)
        const wallet_pubkey = wallet_details['public_key']
        const wallet_id = wallet_details['id']

        // Paymaster
        const paymasterRpc = new PaymasterRpc({ nodeUrl: PAYMASTER_RPC, headers: { 'x-paymaster-api-key': AVNU_PAYMASTER_API } });

        const ARGENT_X_ACCOUNT_CLASS_HASH_V0_5_0 = ARGENT_ACCOUNT_CLASS_HASH;
        const publicKey = wallet_pubkey;

        // Calculate future address of the ArgentX account
        const argentxSigner = new CairoCustomEnum({ Starknet: { pubkey: publicKey } });
        const argentxGuardian = new CairoOption(CairoOptionVariant.None) // to add gaurdian, new CairoOption(CairoOptionVariant.Some, '0x-gurdian-address')

        // Make argentxSigner owner of deployed account
        const AXConstructorCallData = CallData.compile({
            owner: argentxSigner,
            guardian: argentxGuardian
        });


        // Contract address for new ARGENT_X_ACCOUNT
        const AXcontractAddress = hash.calculateContractAddressFromHash(
            publicKey,
            ARGENT_X_ACCOUNT_CLASS_HASH_V0_5_0,
            AXConstructorCallData,
            0
        );

        // Account
        const account = new Account({
            provider: provider, address: AXcontractAddress, signer: new (class extends RawSigner {
                async signRaw(messageHash) {
                    console.log('messageHash=', messageHash);

                    // Get the signature using the privy raw sign method
                    const signature = await privyRawSign(wallet_id, messageHash);

                    const sigWithout0x = signature.signature.slice(2);
                    const r = `0x${sigWithout0x.slice(0, 64)}`;
                    const s = `0x${sigWithout0x.slice(64)}`;
                    return [r, s];
                }
            })(),
            paymaster: paymasterRpc
        })

        // Self funded deployment 
        const deployAccountPayload = {
            classHash: ARGENT_X_ACCOUNT_CLASS_HASH_V0_5_0,
            constructorCalldata: AXConstructorCallData,
            contractAddress: AXcontractAddress,
            addressSalt: publicKey,
            version: 1
        }

        // sponsored deployment
        const SponsoredDeployMentAccountPayload = {
            class_hash: ARGENT_X_ACCOUNT_CLASS_HASH_V0_5_0,
            calldata: CallData.toHex(AXConstructorCallData),
            address: AXcontractAddress,
            salt: publicKey,
            version: 1
        }

        // mark contract calls as sponsored
        const feesDetails = {
            feeMode: { mode: 'sponsored' },
            deploymentData: SponsoredDeployMentAccountPayload
        };

        // If SPONSOR_WITH_PAY_MASTER is false, make user pay own gas costs
        if (!SPONSOR_WITH_PAY_MASTER) {
            const response = await account.deployAccount(deployAccountPayload, {
                skipValidate: false,
            });
            const transaction_hash = await provider.waitForTransaction(response.transaction_hash);
            return transaction_hash
        }

        const res = await account.executePaymasterTransaction([/*empty for deployment of accounts*/], feesDetails);
        const transaction_hash = await provider.waitForTransaction(res.transaction_hash);

        return transaction_hash
    } catch (error) {
        return { "deployArgentXAccount": error }
    }

}

export { deployArgenXAccount }