import { AutoRouter, json, html } from 'itty-router' // ~1kB

const router = AutoRouter()

import { createNewWallet } from './createWallet'
import { getWalletById } from './getWalletById'
import { deployArgenXAccount } from './deployArgentXAccount'
import { increaseCounter } from './increaseCounter'
import { decreaseCounter } from './decreaseCounter'
import { getUserByEmail } from './getUserByEmail'


router
  .get('/create-wallet/:userId',      async ({ userId })   => json(await createNewWallet(userId)))
  .get('/get-wallet-by-id/:walletId', async ({ walletId }) => json(await getWalletById(walletId)))

  .get('/get-user-by-email/:email', async ({ email }) => json(await getUserByEmail(email)))

  .get('/deploy-argentx-account/:walletId',  async ({walletId }) => json(await deployArgenXAccount(walletId)))

  .get('/increase-counter/:walletId',    async ({ walletId }) => json(await increaseCounter(walletId)))
  .get('/decrease-counter/:walletId',    async ({ walletId }) => json(await decreaseCounter(walletId)))


export default { ...router }
