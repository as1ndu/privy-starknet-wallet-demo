import { privy } from "./utils/privy";

async function getWalletById(walletId) {
    try {
        // get details
        const response = await privy.wallets().get(walletId)
        return response
    } catch (error) {
        return { "getWalletById.js": error }
    }
}

export { getWalletById }