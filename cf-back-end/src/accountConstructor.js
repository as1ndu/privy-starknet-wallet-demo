import {
    RpcProvider,
    Account,
    PaymasterRpc
} from "starknet";

import { RawSigner } from "./utils/rawSigner";
import { privyRawSign } from "./privyRawSign";

import { RPC_URL, PAYMASTER_RPC, AVNU_PAYMASTER_API } from "./config";

// Construct Privy account
function accountConstructor(privyContractAddress, privyWalletId) {

    try {
        // Starknet node RPC
        const provider = new RpcProvider({
            nodeUrl: RPC_URL
        });

        // Paymaster RPC
        const paymasterRpc = new PaymasterRpc({ nodeUrl: PAYMASTER_RPC, headers: { 'x-paymaster-api-key': AVNU_PAYMASTER_API } });

        const account = new Account({
            provider: provider, address: privyContractAddress, signer: new (class extends RawSigner {
                async signRaw(messageHash) {
                    console.log('messageHash=', messageHash);

                    // Get the signature using the privy raw sign method
                    const signature = await privyRawSign(privyWalletId, messageHash);

                    const sigWithout0x = signature.signature.slice(2);
                    const r = `0x${sigWithout0x.slice(0, 64)}`;
                    const s = `0x${sigWithout0x.slice(64)}`;
                    return [r, s];
                }
            })(),
            paymaster: paymasterRpc
        })
        return account

    } catch (error) {
        return { "accountConstructor.js": error }
    }

}

export { accountConstructor }