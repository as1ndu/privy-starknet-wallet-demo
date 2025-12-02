import { privy } from "./utils/privy";

import { AUTH_SIGNER_ID } from "./config";

async function createNewWallet(userId) {

    try {
        // Create new starknet wallet
        const response = await privy.wallets().create({
            chain_type: 'starknet',
            owner: { user_id: userId },
            additional_signers: [{
                // Add authorized signer to new wallet
                signer_id: AUTH_SIGNER_ID
            }]
        })
        return response
    } catch (error) {
        return { "createWallet.js": { error } }
    }

}

export { createNewWallet }