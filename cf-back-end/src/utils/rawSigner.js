import { transaction, CallData, hash, stark, typedData, RPC } from "starknet";

export class RawSigner {
    // Override in subclass
    async signRaw(_messageHash){
        throw new Error("signRaw method must be implemented by subclass");
    }

    async getPubKey(){
        throw new Error("This signer allows multiple public keys");
    }

    async signMessage(
        typed,
        accountAddress
    ){
        const messageHash = typedData.getMessageHash(typed, accountAddress);
        return this.signRaw(messageHash);
    }

    async signTransaction(
        transactions,
        details
    ){
        const compiledCalldata = transaction.getExecuteCalldata(
            transactions,
            details.cairoVersion
        );
        let msgHash;
        if (Object.values(RPC.ETransactionVersion2).includes(details.version)) {
            msgHash = hash.calculateInvokeTransactionHash({
                ...details,
                senderAddress: details.walletAddress,
                compiledCalldata,
                version: details.version,
            });
        } else if (
            Object.values(RPC.ETransactionVersion3).includes(details.version)
        ) {
            msgHash = hash.calculateInvokeTransactionHash({
                ...details,
                senderAddress: details.walletAddress,
                compiledCalldata,
                version: details.version,
                nonceDataAvailabilityMode: stark.intDAM(
                    details.nonceDataAvailabilityMode
                ),
                feeDataAvailabilityMode: stark.intDAM(details.feeDataAvailabilityMode),
            });
        } else {
            throw new Error("unsupported signTransaction version");
        }
        return this.signRaw(msgHash);
    }

    async signDeployAccountTransaction(details){
        const compiledConstructorCalldata = CallData.compile(
            details.constructorCalldata
        );
        let msgHash;
        if (Object.values(RPC.ETransactionVersion2).includes(details.version)) {
            msgHash = hash.calculateDeployAccountTransactionHash({
                ...details,
                salt: details.addressSalt,
                constructorCalldata: compiledConstructorCalldata,
                version: details.version,
            });
        } else if (
            Object.values(RPC.ETransactionVersion3).includes(details.version)
        ) {
            msgHash = hash.calculateDeployAccountTransactionHash({
                ...details,
                salt: details.addressSalt,
                compiledConstructorCalldata,
                version: details.version,
                nonceDataAvailabilityMode: stark.intDAM(
                    details.nonceDataAvailabilityMode
                ),
                feeDataAvailabilityMode: stark.intDAM(details.feeDataAvailabilityMode),
            });
        } else {
            throw new Error(
                `unsupported signDeployAccountTransaction version: ${details.version}`
            );
        }
        return this.signRaw(msgHash);
    }

    async signDeclareTransaction(details){
        let msgHash;
        if (Object.values(RPC.ETransactionVersion2).includes(details.version)) {
            msgHash = hash.calculateDeclareTransactionHash({
                ...details,
                version: details.version,
            });
        } else if (
            Object.values(RPC.ETransactionVersion3).includes(details.version)
        ) {
            msgHash = hash.calculateDeclareTransactionHash({
                ...details,
                version: details.version,
                nonceDataAvailabilityMode: stark.intDAM(
                    details.nonceDataAvailabilityMode
                ),
                feeDataAvailabilityMode: stark.intDAM(details.feeDataAvailabilityMode),
            });
        } else {
            throw new Error("unsupported signDeclareTransaction version");
        }
        return this.signRaw(msgHash);
    }
}