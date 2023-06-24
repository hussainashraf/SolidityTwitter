// SPDX-License-Identifier:unlicensed
pragma solidity 0.8.17;

contract TwitterContract{
    struct Twitter{
        uint id;
        address author;
        string content;
        uint createdAt;
    } 

    struct message{
        uint id;
        string content;
        address from;
        address to;
        uint createdAt; 
    }

    mapping(uint=>Twitter) public tweets;
    mapping(address=>uint[])public tweetsOf; 
    mapping(address=>message[]) public conversation;
    mapping(address=>mapping(address=>bool))public operation;
    mapping(address=>address[]) public following;

    uint nextId;
    uint nextmessageId;

    function _tweet(address _from,string memory _content) internal {
        require(_from==msg.sender || operation[_from][msg.sender],"You don't have access");
        tweets[nextId]=Twitter(nextId,_from,_content,block.timestamp);
        tweetsOf[_from].push(nextId);
        nextId++;
    }

    function _sendmessage(address _from,address _to,string memory content) internal{
        require(_from==msg.sender || operation[_from][msg.sender],"You don't have access");
        conversation[_from].push(message(nextmessageId,content,_from,_to,block.timestamp));
        nextmessageId++;

    }

    function tweet(string memory content)public{
        _tweet(msg.sender,content);
    }

    function tweet(address _from,string memory content) public{
        _tweet(_from,content);
    }

    function sendmessage(string memory content,address _to) public {
        _sendmessage(msg.sender, _to, content);
    }

    function sendmessage(address _from, address _to,string memory content) public {
        _sendmessage(_from, _to, content);
    }

    function followed(address _followed) public{
        following[msg.sender].push(_followed);
    }

    function allow (address _operator) public{
        operation[msg.sender][_operator]=true;
    }

    function disallow (address _operator) public{
        operation[msg.sender][_operator]=false;
    }

    function getLatestTweet(uint count) public view returns(Twitter[] memory){
        require(count>0&&count<=nextId,"Count is not proper");
        Twitter[] memory _tweets = new Twitter[](count);

        uint j;
        for(uint i=nextId-count;i<nextId;i++){
            Twitter storage _structure = tweets[i];
            _tweets[j]=Twitter(_structure.id,_structure.author,_structure.content,_structure.createdAt);
            j=j+1;
        }
        return _tweets;
    }

    function getLatestofUser(address _user,uint count) public view returns(Twitter[] memory){
        Twitter[] memory _tweets = new Twitter[](count);
        uint[] memory ids = tweetsOf[_user];
        require(count>0&&count<=ids.length,"Count is not defined");
        uint j;
         for(uint i=ids.length-count;i<ids.length;i++){
            Twitter storage _structure = tweets[ids[i]];
            _tweets[j]=Twitter(_structure.id,_structure.author,_structure.content,_structure.createdAt);
            j=j+1;
        }
        return _tweets;
    }
}
