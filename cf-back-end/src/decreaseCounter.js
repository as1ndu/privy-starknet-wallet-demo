import { callContract } from "./contractCall";


async function decreaseCounter(walletId) {

    try {
        const contract_address = '0x04AA82300034D8495d727abD9436D143B4881D5177dd2be9f71F232E9Ace4743' //contract to call
        const contract_function = 'decrement' // function to call
        const contract_call_data = {
            /* 
            'increment' does not need call data 
            So we just pass an empty object
            */
        }

        const transaction_hash = await callContract(walletId, contract_address, contract_function, contract_call_data)
        return transaction_hash

    } catch (error) {
        return { "decreaseCounter.js": error }
    }


}

export { decreaseCounter }