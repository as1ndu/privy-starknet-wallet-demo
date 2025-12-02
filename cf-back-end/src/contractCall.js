import {
    RpcProvider,
    PaymasterRpc,
    CallData,
} from "starknet";

import { accountConstructor } from "./accountConstructor";

import { RPC_URL, SPONSOR_WITH_PAY_MASTER } from "./config";

import { getWalletById } from "./getWalletById";

async function callContract(walletId, contractAddress, contractFunction, contractCallData) {
    try {
        // Node RPC url
        const provider = new RpcProvider({
            nodeUrl: RPC_URL
        });

        // get privy wallet details
        const walletDetails = await getWalletById(walletId)
        const walletAddress = walletDetails['address']

        // contract call payload
        const contractCallTransaction = {
            contractAddress: contractAddress, // contract address  to call
            entrypoint: contractFunction, // name of contract function to call
            calldata: CallData.compile(
                contractCallData
            )
        };

        // contract call payload
        const sponsoredContractCallTransaction = {
            contractAddress: contractAddress, // contract address  to call
            entrypoint: contractFunction, // name of contract function to call
            call_data: CallData.toHex(
                // call data in the format {} goes here
                contractCallData
            )
        };

        // deploy from Privy wallet 
        const account = accountConstructor(walletAddress, walletId);

        // Require user to pay own gas costs if SPONSOR_WITH_PAY_MASTER is false
        if (!SPONSOR_WITH_PAY_MASTER) {
            const response = await account.execute(contractCallTransaction, {
                skipValidate: false,
            });
            const transaction_hash = await provider.waitForTransaction(response.transaction_hash);
            return transaction_hash
        }

        // mark contract call as sponsored
        const feesDetails = {
            feeMode: { mode: 'sponsored' },
        };

        const response = await account.executePaymasterTransaction([sponsoredContractCallTransaction], feesDetails)
        const transaction_hash = await provider.waitForTransaction(response.transaction_hash);

        return transaction_hash

    } catch (error) {
        return { "contractCall.js": error }
    }
}

export { callContract }
