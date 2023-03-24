// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract DRS_DATA_STORE {
    struct DrivingData {
        uint256 braking;
        uint256 dangerousBrake;
        uint256 dangerousTurn;
        uint256 dangerousSpeed;
        string averageSpeed;
        uint256 drivingTime;
        string date;
        uint256 score;
    }

    struct SetOfAddress {
        uint256 sizeOfSet;
        address[] values;
        mapping(address => bool) is_in;
    }

    struct User {
        DrivingData[] data;
        uint256 updateCount;
        string lastUpdate;
        uint256 lastScore;
    }

    struct ResponseData {
        address user;
        uint256 updateCount;
        string lastUpdate;
        uint256 lastScore;
    }

    mapping(address => User) private users;
    SetOfAddress private _userSetAddress;
    SetOfAddress private _companySetAddress;
    address[] private _adminAddress = [
        0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1,
        0x2c41E9c7A248d955493Ba6D8A26722ee3dB9631f,
        0x6D9f4d92839c5BCe7C4Dd958605dFc1C2eBdE7Fd
    ];
    // service address
    function addUserAddress(address member) public returns (string memory) {
        require(
            !_userSetAddress.is_in[member],
            "Error address is in user address"
        );
        require(
            msg.sender == _adminAddress[0] ||
                msg.sender == _adminAddress[1] ||
                msg.sender == _adminAddress[2],
            "You are not an admin"
        );

        _userSetAddress.values.push(member);
        _userSetAddress.is_in[member] = true;
        _userSetAddress.sizeOfSet++;

        return "Succeed";
    }

    function addCompanyAddress(address member) public returns (string memory) {
        require(
            !_companySetAddress.is_in[member],
            "Error address is in company address"
        );
        require(
            msg.sender == _adminAddress[0] ||
                msg.sender == _adminAddress[1] ||
                msg.sender == _adminAddress[2],
            "You are not an admin"
        );

        _companySetAddress.values.push(member);
        _companySetAddress.is_in[member] = true;
        _companySetAddress.sizeOfSet++;

        return "Succeed";
    }

    function getSizeOfUserAddress() public view returns (uint256) {
        return _userSetAddress.sizeOfSet;
    }

    function getAllUserAddress() public view returns (address[] memory) {
        address[] memory result = new address[](_userSetAddress.sizeOfSet);
        for (uint256 i = 0; i < _userSetAddress.sizeOfSet; i++) {
            result[i] = _userSetAddress.values[i];
        }
        return result;
    }

    function getSizeOfCompanyAddress() public view returns (uint256) {
        return _companySetAddress.sizeOfSet;
    }

    function getAllCompanyAddress() public view returns (address[] memory) {
        address[] memory result = new address[](_companySetAddress.sizeOfSet);
        for (uint256 i = 0; i < _companySetAddress.sizeOfSet; i++) {
            result[i] = _companySetAddress.values[i];
        }
        return result;
    }
    // company data service 
    function companyGetUsers() public view returns (ResponseData[] memory) {
        address result;
        ResponseData[] memory my_response = new ResponseData[](
            _userSetAddress.sizeOfSet
        );
        for (uint256 i = 0; i < _userSetAddress.sizeOfSet; i++) {
            result = _userSetAddress.values[i];
            my_response[i] = ResponseData(
                result,
                users[result].updateCount,
                users[result].lastUpdate,
                users[result].lastScore
            );
        }
        return my_response;
    }

    function companyGetUserDrivingData(address user) public view returns (DrivingData[] memory){
        require(
            _companySetAddress.is_in[msg.sender],
            "Error address is in company address"
        );
        return users[user].data;
    }
    // user data service 
    function userAddDrivingData(DrivingData[] memory _dataArray) public returns (string memory){
        require(
            _userSetAddress.is_in[msg.sender],
            "Not have address in system"
        );

        for (uint256 i = 0; i < _dataArray.length; i++) {
            users[msg.sender].data.push(_dataArray[i]);
            users[msg.sender].updateCount++;
            if (i == _dataArray.length - 1) {
                users[msg.sender].lastUpdate = _dataArray[i].date;
                users[msg.sender].lastScore = _dataArray[i].score;
            }
        }

        return "Succeed";
    }
    
    function userGetUserDrivingData() public view returns (DrivingData[] memory){
        return users[msg.sender].data;
    }

}
