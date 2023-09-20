import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Prelude "mo:base/Prelude";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";


actor Token {

    var owner : Principal = Principal.fromText("vjqvg-opd27-dxyi2-576oz-fhdqe-jfg4b-7zt2q-ae4yr-65tcw-f2cti-bae");  
    var totalSupply : Nat = 231400000; //231.4 Million
    var symbol : Text = "JUG";

    var balances = HashMap.HashMap<Principal,Nat>(1,Principal.equal, Principal.hash); //Our ledger to keep track of balances

    balances.put(owner,totalSupply);


    public query func balanceOf(who: Principal): async Nat{
        
        let balance : Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol(): async Text{ //faster query method to just read data from blockchain
        return symbol;
    };

    public shared(msg) func payOut(): async Text{ // here msg is the principal id of the entity who will call this shared functions from their actors
        Debug.print(debug_show(msg.caller));

        if(balances.get(msg.caller) == null){
            let amount = 2500;
            balances.put(msg.caller,amount);
            let ownerBal : Nat = await balanceOf(owner);
            balances.put(owner, ownerBal - amount);
            return "JUGAAR works. JUG has been deposited";
        }else {
            return "JUGAAR PE JUGAAR. You have already claimed JUG";
        }
        
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text{

        let sender : Principal = msg.caller;
        let receiver: Principal = to;

        let senderBal : Nat = await balanceOf(sender);
        let receiverBal : Nat = await balanceOf(receiver);

        let diff : Nat = senderBal - amount;


        if(sender==receiver){
            return "Nice Try to Jugaar. Cant send JUGS to yourself";
        }else if(diff>=0){
            balances.put(sender, senderBal - amount);
            balances.put(receiver, receiverBal + amount);
            return "JUGAAR done";
        }
        else{
            return "JUGAAR Failed. Not enough JUGS";
        }

        

    };
};