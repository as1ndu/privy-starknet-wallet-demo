import { privy } from "./utils/privy";

async function getUserByEmail(userEmail) {
    try {
        // get user details
        const response = await privy.users().getByEmailAddress({ address: userEmail })
        return response
    } catch (error) {
        return { "getUserByEmail.js": error }
    }
}

export { getUserByEmail }