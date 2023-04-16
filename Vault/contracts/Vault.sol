/**
 * Kullanıcılar, belirli bir miktar tokenlerini contrata kitleyecek
 * Karşılığında, kitleme süresi ve kitlenilen miktar kadar staking ödülü alıcaklar.
 * Kullanıcı, daha erken çekmeye çalışırsa kitlediği tokenleri, %10 kadar bir kesintiyle çekecekler
 */
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Vault {

    uint private constant punishedWithdraw = 10; 
    uint private constant fee = 5;


    mapping(address => uint) private stakeAmounts;
    mapping(address => uint) private stakeTimes;

    event Staked(address indexed user, uint amount, uint time);
    event Withdraw(address indexed user, uint amount, uint time);
    event WithdrawBeforeTime(address indexed user, uint amount, uint time);

    constructor() payable {}
    modifier onlyStaker() {
        require(stakeAmounts[msg.sender] > 0, "You are not a staker");
        _;
    }

    modifier stakeTimeFinished() {
        require(stakeTimes[msg.sender] < block.timestamp, "You can not withdraw before time");
        _;
    }

    // 10 saat , 10 * 3600 , 36000, 
    function stake(uint _stakeTime) public payable returns(bool){
     
        require(msg.value > 0, "You can not stake 0 amount");
        uint withFeeAmount = msg.value - calculateFee(msg.value);
        stakeAmounts[msg.sender] = withFeeAmount;
        stakeTimes[msg.sender] = block.timestamp + _stakeTime * 3600;   
        emit Staked(msg.sender, withFeeAmount, block.timestamp);
        return true;
    }

    function calculateFee(uint _amount) private pure returns(uint){
        return _amount * fee / 100;
    }

    /**
    reward = (_amount * time) / 1000 // 10 bnb 10 saat = 0.1 BNB, 50 BNB 10 saat = 0.5 , 40 BNB 100 saat = 4 BNB 
    1 BNB 1000 = 1 BNB 
    */
    function calculateReward(uint _amount, uint _time) public pure returns(uint){
        return (_amount * _time) / 1000;
    }

    function withdraw() public onlyStaker stakeTimeFinished returns(bool){
        uint amount = stakeAmounts[msg.sender];
        uint time = stakeTimes[msg.sender];
        stakeAmounts[msg.sender] = 0;
        stakeTimes[msg.sender] = 0;
        uint reward = amount;
        payable(msg.sender).transfer(reward);
        emit Withdraw(msg.sender, reward, block.timestamp);
        return true;
    }

    function withdrawBeforeTime() public onlyStaker returns(bool){
        uint amount = stakeAmounts[msg.sender];
        uint punishedAmount = amount * punishedWithdraw / 100;
        uint withdrawAmount = amount - punishedAmount;

        stakeAmounts[msg.sender] = 0;
        stakeTimes[msg.sender] = 0;
        
        payable(msg.sender).transfer(withdrawAmount);
        
        emit WithdrawBeforeTime(msg.sender, withdrawAmount, block.timestamp);
        return true;
    }

    /**
     * Kullanıcının kitlediği miktar
     * @param _staker - Staker'ın adresi
     * @return - Kitleme miktarı
     */
    function getStakeAmount(address _staker) public view returns(uint){
        return stakeAmounts[_staker];
    }


    /**
     * Kullanıcın stake süresi
     * @return - Kullanıcın stake süresi
     */
    function getStakeTime(address _staker) public view returns(uint){
        return stakeTimes[_staker];
    }

    /**
     * Kullanıcının withdraw yapabilmesi için kalan süre
     * @param _staker - Staker'ın adresi
     * @return - Kalan süre
     */
    function getStakeTimeLeft(address _staker) public view returns(uint){
        if(stakeTimes[_staker] - block.timestamp <= 0 ) {
            return 0;
        }
        return stakeTimes[_staker] - block.timestamp;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    receive() external payable{
        revert();
    }

}