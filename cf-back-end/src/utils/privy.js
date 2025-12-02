import {PrivyClient} from '@privy-io/node';

import { APP_ID, APP_SECRET } from '../config';

// create Privy client
const privy = new PrivyClient({
  appId: APP_ID,
  appSecret: APP_SECRET
});

export { privy }