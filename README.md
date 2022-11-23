Welcome! You are about to learn how to code your first smart contract. This small tutorial assumes you have learned the basics of blockchain but have never created any smart contract before. You'll learn how to send and receive funds; work with mappings, address types and unsigned integers(uint).

## What is a Smart Contract?
A smart contract is a computer program that runs on a blockchain. Just the way we have apps that run on Android or Windows, a smart contract is literally an app that runs on a blockchain. The ability to create a smart contract today is a highly sought-after skill by employers in the new economy.

## Set up Remix
Before we can write a smart contract, we will need a development environment. To make the process easier and faster, we will use Remix. Remix is a web-based code editor for building and deploying Ethereum smart contracts.

![image.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669044908821/gIoPAhv3P.png)

Open a new browser tab and proceed to [remix.ethereum.com](https://remix.ethereum.org/).

> You may see a prompt asking you to allow Remix to track your usage, decline or accept so we can proceed. Also, you can close any existing tab on the editor e.g Home.

The first thing we will do is to expand the folder called `contracts` on the left side of Remix IDE and create a new file called `VendingMachine.sol`.

> To create a new file, click the file icon once the `contracts` folder is expanded or right-click on the `contracts` folder for options.

Your Remix should look similar to the screenshot below.

![image.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669045060509/928orVfCV.png)

## Define the contract
When writing a smart contract, the first thing we want to do is to set our license identifier.

```solidity
// SPDX-License-Identifier: MIT
```

> SPDX license identifiers were [introduced](https://forum.openzeppelin.com/t/solidity-0-6-8-introduces-spdx-license-identifiers/2859) in version **0.6.8** so developers can specify the license the contract uses at the top of our contract file e.g Our VendingMachine contract will use MIT.

The next line is to specify the version of solidity we are going to use.

```solidity
pragma solidity ^0.8.11;
```

Then next we will go ahead and define our contract:

```solidity
contract VendingMachine {

}
```

> The `contract` keyword comes first when defining a contract in Solidity. And the next word is the name of the contract usually in CamelCase. This is similar to creating a class in Javascript or C++.

Your code should look like this now:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine {

}
```

## Define state variables
State variables are variables that are going to be stored on the blockchain and they are also going to persist between multiple calls of the smart contract.

There are two state variables we will need for our Vending Machine contract:

1. owner
2. balances

The `owner` represents the owner of the vending machine. And will collect funds and also restock the vending machine. The `balances` will hold the balances of both the vending machine and everyone who has interacted with it.

**Let's define both. Inside the `contract` code add the following code.**

```solidity
 // state variables
 address public owner;
 mapping (address => uint) public donutBalances;
```

The `address` is a data type in Solidity that holds a 20-byte value, which is the size of an Ethereum address. The `public` means the variable `owner` will be publicly available in the blockchain and anyone can access and interact with it.

The `mapping` is a new data type in Solidity, and you can think of it as an [object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_Objects) in Javascript but all of the values are of the same type. So in the code, we are simply mapping the Ethereum address with the number of donuts each address owns. The `uint` just means each donut balance must be a positive whole number.

Our code should now look like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine {
     // state variables
     address public owner;
     mapping (address => uint) public donutBalances;
}
```

## Define the constructor
Whenever a smart contract is deployed, the [constructor](https://solidity-by-example.org/constructor/) will get called once. Let's take advantage of that and set up the `owner` and the donutBalance of the vending machine.

> A constructor in solidity is an optional function that is called once whenever a contract is deployed or initialized. It is usually used to initiate state variables in a smart contract.

Add the following code after the state variables.

```solidity
// set the owner as the address that deployed the contract
// set the initial vending machine to 100
constructor() {
      owner = msg.sender;
      donutBalances[address(this)] = 100;
}
```
Now whenever our contract is deployed, the `owner` and donut balance of the vending machine are set.

## Create the functions
We will need functions to execute the purchase of donuts, restock and get the balance of the vending machine.

> A function is a group of reusable code which can be called anywhere in your contract depending on the visibility. This eliminates the need of writing the same code again and again. In Solidity a function is generally defined by using the `function` keyword, followed by the name of the function which is unique.

Let's create the get balance function. Add the following code below the constructor.

```solidity
function getVendingMachineBalance() public view returns (uint) {
    return donutBalances[address(this)];
}
```

This function returns the donut balance of the vending machine wherever it will be called. It has the keyword `view ` signifying it can only read state variables from the contract and can't modify them.

The `address(this)` refers to the balance of [this](https://www.geeksforgeeks.org/difference-between-this-and-addressthis-in-solidity/) contract that is deployed.

**Next, let's create the restock function.**

```solidity
// Let the owner restock the vending machines
function restock(uint amount) public {
    require(msg.sender == owner, "Only the owner is allowed to restock the vending machine.");
    donutBalances[address(this)] += amount;
}
```

The `restock` function will be called whenever we want to restock the vending machine. The `require` is an error handling function that set the condition if the `msg.sender` is the same as the owner else an error is thrown. Remember the `msg.sender` is the contract address that has called or initiated the `restock` function. So we are only letting the owner restock the vending machine.

**Finally for the functions, let's create the purchase function.**

```solidity
// Purchase donuts from the vending machine
// require minimum ether payment
// require if enough donuts in stock
function purchase(uint amount) public payable {
    require(getVendingMachineBalance() >= amount, "There is no enough donuts in stocks to complete the purchase.");
    require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut.");
    donutBalances[address(this)] -= amount;
    donutBalances[msg.sender] += amount;
}
```

This function has the keyword `payable` signifying it can receive ether. It takes in an `amount` which must be a positive number (uint). 
 
Using the `require` again we check if the vending machine balance in stock is enough for the amount of purchase to be made, and also the contract address must pay a minimum gas fee of 2 ether per donut. Then we deduct the balance of the vending balance `address(this)` and increment the balance of the contract address that made the purchase `msg.sender`.

The final code of our contract should look like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine {

    // state variables
    address public owner;
    mapping (address => uint) public donutBalances;

    // set the owner as the address that deployed the contract
    // set the inital vending machine to 100
    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 1;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    // Let the owner restock the vending machines
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner is allowed to restock the vending machine.");
        donutBalances[address(this)] += amount;
    }

    // Purchase donuts from the vending machine
    // require minimum ether payment
    // require if enough donuts in stock
    function purchase(uint amount) public payable {
        require(getVendingMachineBalance() >= amount, "There is no enough donuts in stocks to complete the purchase.");
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut.");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }
}
```

It's now time to deploy.

## Deploy the contract
On the left side menu of Remix, navigate to the Solidity Compiler (the third icon). Select the right version of Solidity, in our case 0.8.17, and click the Compile button to compile the contract.

![remix-solidity-compiler.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669161611726/uS-pO2X0o.png)

> If the compilation has an error, it will be displayed below the "Compile VendingMachine.sol" button. Kindly ensure you follow the code correctly.

Once the compilation is successful, the next is to Deploy & run transactions. **Navigate to the next icon on the left menu (Deploy & run transactions). Select "Remix VM(London)" as the environment and click on Deploy**.

![remix-deploy-run-transactions.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669161086049/sIrZ5GTmy.png)

Below the "Deploy" button, in the "Deployed Contract" section, expand the contract. You will see a representation of all of the state variables and functions defined. Let's go ahead and start testing this out.

First, let's get the vending machine balance by clicking on the `getVendingMachineBalance` representation. This will display 100 and if you remember we set this balance when we were defining the constructor.  You can also see the owner's address by clicking on the `owner` representation.

![testing-each-deployed-contract.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669162349805/NiMJ3Mr9M.png)

Next, let's try to purchase a donut. Enter 2 in the `purchase` representation and click on it. Oops! I forgot that will throw an error in the Remix console, remember we `require` that 2 ether will be charged per donut purchase. So scroll up a little bit and specify the amount of ether we want to pay for this transaction.

![remix-deploy-pay-gas-fees.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669163672769/Fr2pj4l0b.png)

Scroll down and click the `purchase` representation, and wait for a few seconds, the purchase will be successful.

To confirm, scroll up and copy the *account* address and paste it inside the `donutBalances` representation, click it and the balance (1) will show beneath. click `getVendingMachineBalance` to see if the balance is reduced to 99.

![remix-copy-account-contract.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1669164992729/XgC9lbbrg.png)

## Test your knowledge
Try to restock the vending machine yourself. Remember the vending machine balance is now 99 no longer 100.

If you encounter any error or you are stuck for any reason, kindly  [open an issue](https://github.com/jeremyikwuje/your-first-smart-contract/issues). 

## Conclusion
Congratulation! you have successfully created and deployed your first smart contract. You learned how to send and receive funds; work with mappings, address types and unsigned integers(uint).

**Become a Web3/Blockchain engineer in 8 weeks. [Apply Now!](https://school.forward.africa?utm_source=your-first-smart-contract&utm_medium=github)**
