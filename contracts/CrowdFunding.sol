// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC20 {
    function transfer(address, uint) external returns (bool);

    function transferFrom(address, address, uint) external returns (bool);
}

contract CrowdFund {
    event Launch(uint id, address indexed creator, uint goal);
    event Contribute(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Drive {
        address creator;
        uint goal;
        uint pledged;
        bool claimed;
    }

    IERC20 public immutable token;

    uint public count;

    mapping(uint => Drive) public drives;

    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal) external {
        count += 1;
        drives[count] = Drive({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            claimed: false
        });
        emit Launch(count, msg.sender, _goal);
    }

    function contribute(uint _id, uint _amount) external {
        Drive storage drive = drives[_id];

        drive.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        // Calling the event contribute
        emit Contribute(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Drive storage drive = drives[_id];
        require(drive.creator == msg.sender, "not creator");
        require(!drive.claimed, "claimed");

        drive.claimed = true;
        token.transfer(drive.creator, drive.pledged);

        // Calling the Clain event
        emit Claim(_id);
    }

    function refund(uint _id) external {
        uint balance = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer((msg.sender), balance);

        // Calling the Refund event
        emit Refund(_id, msg.sender, balance);
    }
}
