# privy_starknet_wallet

 Privy Starknet Wallet Demo.

 ## Installing dependencies

 - Step 1: Clone this repo
  
 - Step 2: Make sure your in the flutter directory `$ cd privy_starknet_wallet`
  
 - Step 3: Install dependecies `$ flutter pub get`
  
 - Step 4: Update configs file `lib/config.dart`

## Configs

Modify `lib/config.dart`

- `baseURL` the domain name of your backend, server deployment. For a local machine it should be `localhost:8787`;

- `rpcURL` RPC node

## Run the wallet

- Get the backend up & first.
  
- Run the application `$ flutter pub get`

## Contract calls

### Write  operations

Privy does not yet support the export of private keys. So write operations will have to be done on the server via Authorization keys.

- `lib/contracts/decrease_counter.dart` calls `decrease` through privy on the backend.

- `lib/contracts/increase_counter.dart` calls `increase` through privy on the backend.

```dart
// snippet from lib/contracts/increase_counter.dart
Future<dynamic> increaseCounter() async {
  // ..

  //...

  // just make a HTTP call to your backend server
  String urlPath = '/increase-counter/$walletId';
  Map value = await makeRequest(urlPath);

  return value;
}
```

### Read operation

Since read operationd don't need gas, they can be called via `https://pub.dev/packages/starknet`

- `lib/contracts/get_counter_value.dart`  uses [starknet.dart](https://pub.dev/packages/starknet) to read from the 

```dart
// snippet from `lib/contracts/get_counter_value.dart`
final result = await provider.call(
    request: FunctionCall(
      contractAddress: Felt.fromHexString(
        // Supply counter contract address
        '0x04AA82300034D8495d727abD9436D143B4881D5177dd2be9f71F232E9Ace4743',
      ),
      // entry point or function name
      entryPointSelector: getSelectorByName("get_current_count"),

      // call data
      calldata: [],
    ),
    blockId: BlockId.latest,
  );
```
