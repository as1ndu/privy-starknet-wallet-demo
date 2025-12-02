# Starknet Privy Wallet Demo (Backend)

Backend for Starknet Privy Wallet Demo with Flutter client

## Table of Contents

- [Starknet Privy Wallet Demo (Backend)](#starknet-privy-wallet-demo-backend)
  - [Table of Contents](#table-of-contents)
    - [Installation](#installation)
    - [Configurations](#configurations)
    - [Running locally \& production deployment](#running-locally--production-deployment)
    - [API end points](#api-end-points)
      - [Variable definitions](#variable-definitions)
      - [End points](#end-points)

### Installation

- Step 1: Clone this repo
- Step 2: `$ cd /privy-starknet-wallet-demo/cf-back-end`
- Step 3: Make sure you have `yarn`, run `$ npm install -g yarn`
- Step 4: Install all dependencies `$ yarn install`
- Step 5: Setup necessary configurations in `src/config.js`

### Configurations

These configurations can be set in `src/config.js`. For production, please store config values as [secrets](https://developers.cloudflare.com/workers/configuration/secrets/)

`RPC_URL`, RPC URL for starknet network, Alchemy, Infura etc (can be `mainet` or `sepolia` RPC, spec version 10+)

`AUTHORIZATION_PRIVATE_KEYS`, Autorization key you created in Privy ([see more](https://docs.privy.io/controls/authorization-keys/keys/create/key))

`AUTH_SIGNER_ID`, `id` for Autorization key you created in Privy ([see more](https://docs.privy.io/controls/authorization-keys/keys/create/key))

`APP_ID`, `appId` for Privy application ([see more](https://docs.privy.io/basics/get-started/dashboard/create-new-app))

`APP_SECRET`, `appSecret` for Privy application ([see more](https://docs.privy.io/basics/get-started/dashboard/create-new-app))

`ARGENT_ACCOUNT_CLASS_HASH`, ARGENT Account abtraction for wallets. We reccomend version 5 deployed at [0x073414441639dCD11d1846f287650a00c60c416b9D3ba45D31C651672125b2C2](https://sepolia.voyager.online/class/0x073414441639dCD11d1846f287650a00c60c416b9D3ba45D31C651672125b2C2), ([see more](https://github.com/argentlabs/argent-contracts-starknet/blob/main/docs/SUMMARY.md))

`SPONSOR_WITH_PAY_MASTER`, `true` will use sponsor transactions for users, `false` will require they cover thier own gas costs

`PAYMASTER_RPC`, RPC url for paymaster

`AVNU_PAYMASTER_API`, API key to paymaster RPC

### Running locally & production deployment

To run this locally, make sure you are in the root directory of the backend server;
`$ pwd` output  should end with `/privy-starknet-wallet-demo/cf-back-end`

Once confirmed, run it locally with `$ sudo npx wrangler dev`

### API end points

API end points that the Flutter app will be making calls to, in order to access and create Privy wallets.

#### Variable definitions

`userId`   :  is the unique identifer for each user

`walletId` : is the unique identifer for each user

`email`    : is the unique email a user signed up with

***

#### End points


`GET` - `/create-wallet/:userId`, Create a new wallet for `userId`

`GET` - `/get-wallet-by-id/:walletId`, Retrive wallet details via `walletId`

`GET` - `/get-user-by-email/:email`, Retrive user details via `email`

`GET` - `/deploy-argentx-account/:walletId`, Deploy ArgentX account for `walletId`

`GET` - `/increase-counter/:walletId`, Make `increase` contract call from  `walletId` to counter contract address

`GET` - `/decrease-counter/:walletId`, Make `decrease` contract call from  `walletId` to counter contract address