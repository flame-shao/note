// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract FlameCoin {
    //1. 定义minter、balance
    address public minter;
    mapping(address => uint) public balances;

    //2. 事件允许客户端对您声明的特定合约变化做出反应
    event Sent(address from, address to, uint amount);

    //3. 构造函数 只有在合约创建时运行
    constructor() {
        minter = msg.sender;
    }

    //4. 挖矿 向一个地址发送一定数量的新创建的代币 但只能由合约创建者调用
    function mint(address receiver, uint amount) public {
        require(minter == receiver);
        balances[receiver] += amount;
    }

    //5. 错误类型变量允许您提供关于操作失败原因的信息。
    // 会返回给函数的调用者。
    error InsufficientBalance(uint request, uint available);

    //6. 从任何调用者那里发送一定数量的代币到一个地址
    function send(address to, uint amount) public {
        // 转发数量不能超过账户余额
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance({
                request: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Sent(msg.sender, to, amount);
    }
}
