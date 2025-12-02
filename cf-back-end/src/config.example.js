/*
Rename from config.example.js  to config.js

For production, please store config values as [secrets](https://developers.cloudflare.com/workers/configuration/secrets/)
*/

// RPC
const RPC_URL = 'https://starknet-sepolia.g.alchemy.com/starknet/version/rpc/v0_10/your-api-key'

// authorization_private_keys
const AUTH_SIGNER_ID = 'authorization-siger-id'
const AUTHORIZATION_PRIVATE_KEYS = 'authorization-siger-private-keys'

//Privy App ID & Secret
const APP_ID = 'id' // appId
const APP_SECRET = 'secret' // appSecret

// Argent account class hash
const ARGENT_ACCOUNT_CLASS_HASH = "0x073414441639dcd11d1846f287650a00c60c416b9d3ba45d31c651672125b2c2"

// Paymaster configs
const SPONSOR_WITH_PAY_MASTER = true
const PAYMASTER_RPC = 'https://sepolia.paymaster.avnu.fi'
const AVNU_PAYMASTER_API = ''


export {
    RPC_URL,
    AUTHORIZATION_PRIVATE_KEYS,
    AUTH_SIGNER_ID,
    APP_ID, 
    APP_SECRET,
    ARGENT_ACCOUNT_CLASS_HASH,
    AVNU_PAYMASTER_API,
    SPONSOR_WITH_PAY_MASTER,
    PAYMASTER_RPC
}