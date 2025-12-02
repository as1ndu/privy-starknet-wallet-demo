import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

import '../config.dart';

Future<int> getCurrentCount() async {
  final provider = JsonRpcProvider(nodeUri: Uri.parse(rpcURL));

  final result = await provider.call(
    request: FunctionCall(
      contractAddress: Felt.fromHexString(
        // Supply contract address
        '0x04AA82300034D8495d727abD9436D143B4881D5177dd2be9f71F232E9Ace4743',
      ),
      // entry point
      entryPointSelector: getSelectorByName("get_current_count"),

      // call data
      calldata: [],
    ),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get counter value"),
  );
}
