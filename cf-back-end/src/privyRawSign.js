import { privy } from "./utils/privy";

import { AUTHORIZATION_PRIVATE_KEYS } from "./config";


async function privyRawSign(walletId, msgHash) {

    try {
        //await privy.utils().auth().verifyAuthToken(jwt_token);
        const privateKey = await privy.wallets().rawSign(walletId,
            {
                params: {
                    hash: msgHash
                },
                authorization_context: {
                    authorization_private_keys: [AUTHORIZATION_PRIVATE_KEYS],
                }
            }
        );
        return privateKey
    } catch (error) {
        return { "privyRawSign.js": error }
    }

}

export { privyRawSign }
