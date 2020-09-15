pragma solidity ^0.4.21;

contract exchange {
    struct Data {
        address other;
        bytes32 a;
        bytes32 b;
        uint32 h;
        uint256 m;
    }

    mapping(address => Data) data;

    function exchange() public {}

    function sha_256(bytes32 r) public constant returns (bytes32) {
        return sha256(r);
    }

    function In(
        address other_,
        bytes32 a_,
        bytes32 b_,
        uint32 h_
    ) public payable returns (bytes32) {
        data[msg.sender] = Data({
            other: other_,
            a: a_,
            b: b_,
            h: h_,
            m: msg.value
        });
        return data[msg.sender].a;
    }

    function Out1(
        address owner,
        bytes32 a_,
        bytes32 b_
    ) public constant returns (bool) {
        if (
            block.number < data[owner].h &&
            sha256(a_) == data[owner].a &&
            sha256(b_) == data[owner].b
        ) {
            data[owner].other.send(data[owner].m);
            return true;
        } else {
            return false;
        }
    }

    function Out2(address owner) public constant returns (bool) {
        if (data[msg.sender].h < block.number) {
            msg.sender.send(data[msg.sender].m);
            return true;
        } else {
            return false;
        }
    }

    function GetData(address owner) public constant returns (bytes32) {
        return data[owner].a;
    }
}
