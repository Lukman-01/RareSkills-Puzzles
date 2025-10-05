# Buggy ERC-20 Challenges - Security Findings

This document provides a comprehensive overview of security vulnerabilities found in each challenge contract, along with their mitigations.

---

## Challenge 01: Missing Balance Deduction in Transfer

### Issue/Bug
**Location:** Line 87 in `_transfer()` function  
**Severity:** Critical

The `_transfer` function fails to deduct tokens from the sender's balance, only adding tokens to the recipient. This allows unlimited token creation.

```solidity
function _transfer(address from, address to, uint256 value) internal {
    if (from == address(0)) revert InvalidSender(from);
    if (to == address(0)) revert InvalidReceiver(to);

    uint256 fromBalance = _balances[from];
    if (fromBalance < value) revert InsufficientBalance(from, fromBalance, value);

    //@audit-issue Missing balance deduction for sender
    _balances[to] += value;  // Only adds to recipient, never subtracts from sender
    emit Transfer(from, to, value);
}
```

**Impact:** 
- Sender can transfer unlimited tokens without losing any balance
- Breaks token supply invariant (sum of balances exceeds total supply)
- Complete loss of token value and integrity

### Mitigation
```solidity
function _transfer(address from, address to, uint256 value) internal {
    if (from == address(0)) revert InvalidSender(from);
    if (to == address(0)) revert InvalidReceiver(to);

    uint256 fromBalance = _balances[from];
    if (fromBalance < value) revert InsufficientBalance(from, fromBalance, value);

    unchecked {
        _balances[from] = fromBalance - value;  //  Deduct from sender
    }
    _balances[to] += value;
    emit Transfer(from, to, value);
}
```

---

## Challenge 02: Unrestricted Approve Function

### Issue/Bug
**Location:** Line 58 in `approve()` function  
**Severity:** Critical

The `approve` function accepts an `owner` parameter instead of using `msg.sender`, allowing anyone to set allowances for any address.

```solidity
function approve(address owner, address spender, uint256 amount) public {
    //@audit-issue Anyone can approve tokens from any address (not restricted to msg.sender)
    allowance[owner][spender] = amount;
    emit Approval(owner, spender, amount);
}
```

**Impact:**
- Anyone can grant themselves unlimited allowance from any token holder
- Complete theft of all tokens in the contract
- Violates ERC-20 standard (approve should only work for msg.sender)

### Mitigation
```solidity
function approve(address spender, uint256 amount) public virtual returns (bool) {
    allowance[msg.sender][spender] = amount;  //  Use msg.sender as owner
    emit Approval(msg.sender, spender, amount);
    return true;
}
```

---

## Challenge 03: Public Burn Function Without Access Control

### Issue/Bug
**Location:** Line 37 in `burn()` function  
**Severity:** Critical

The `burn` function is public and allows anyone to burn tokens from any account without approval or ownership verification.

```solidity
function burn(address account, uint256 value) public {
    //@audit-issue function is public and allows anyone to burn tokens from any account
    require(account != address(0), "Invalid burner");
    uint256 accountBalance = _balances[account];
    require(accountBalance >= value, "Insufficient balance");

    _balances[account] = accountBalance - value;
    _totalSupply -= value;
    emit Transfer(account, address(0), value);
}
```

**Impact:**
- Any user can destroy tokens belonging to other users
- Griefing attack vector
- Complete loss of funds for victims

### Mitigation
```solidity
function burn(uint256 value) public {
    address account = msg.sender;  //  Only burn caller's tokens
    require(account != address(0), "Invalid burner");
    uint256 accountBalance = _balances[account];
    require(accountBalance >= value, "Insufficient balance");

    _balances[account] = accountBalance - value;
    _totalSupply -= value;
    emit Transfer(account, address(0), value);
}
```

---

## Challenge 04: Paused Mechanism Bypass via TransferFrom

### Issue/Bug
**Location:** Line 68 in `transferFrom()` function  
**Severity:** High

The pause mechanism only affects the `transfer()` function but not `transferFrom()`, allowing transfers while the contract is paused.

```solidity
function transfer(address to, uint256 value) public returns (bool) {
    require(!paused, "Challenge4: transfers paused");  //  Has pause check
    _transfer(msg.sender, to, value);
    return true;
}

function transferFrom(address from, address to, uint256 value) public returns (bool) {
    //@audit-issue paused mechanism doesn't apply to transferFrom()
    _spendAllowance(from, msg.sender, value);  //  No pause check
    _transfer(from, to, value);
    return true;
}
```

**Impact:**
- Emergency pause can be completely bypassed
- Renders pause functionality ineffective
- Cannot stop transfers during emergency situations

### Mitigation
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(!paused, "Challenge4: transfers paused");  //  Add pause check
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value);
    return true;
}
```

---

## Challenge 05: Reversed Transfer Parameters

### Issue/Bug
**Location:** Line 73 in `transferFrom()` function  
**Severity:** Critical

The parameters in `_transfer()` call are reversed, causing tokens to be transferred from recipient to sender instead.

```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _spendAllowance(from, msg.sender, value);
    //@audit-issue mis arrangement of _transfer parameters
    _transfer(to, from, value);  //  Parameters reversed!
    return true;
}
```

**Impact:**
- TransferFrom sends tokens in the wrong direction
- Recipient loses tokens instead of sender
- Complete breakdown of transferFrom functionality

### Mitigation
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value);  //  Correct parameter order
    return true;
}
```

---

## Challenge 06: Missing Blacklist Check in Approve

### Issue/Bug
**Location:** Line 68 in `approve()` function  
**Severity:** Medium

The `approve` function lacks blacklist validation, allowing blacklisted addresses to create allowances.

```solidity
function approve(address spender, uint256 value) public returns (bool) {
    //@audit-issue approve function lacks the blacklist check
    _approve(msg.sender, spender, value);
    return true;
}
```

**Impact:**
- Blacklisted users can still approve spenders
- Spenders can then use transferFrom to move blacklisted users' tokens
- Undermines blacklist enforcement

### Mitigation
```solidity
function approve(address spender, uint256 value) public returns (bool) {
    require(!blacklist[msg.sender] && !blacklist[spender], 
            "Sender or spender blacklisted");  //  Add blacklist check
    _approve(msg.sender, spender, value);
    return true;
}
```

---

## Challenge 07: Unrestricted Mint Function

### Issue/Bug
**Location:** Line 91 in `mint()` function  
**Severity:** Critical

The `mint` function lacks access control, allowing anyone to mint unlimited tokens.

```solidity
function mint(address to, uint256 value) public {
    //@audit-issue mint function lacks access control
    _mint(to, value);
}
```

**Impact:**
- Anyone can mint unlimited tokens
- Complete destruction of token value
- Hyperinflation attack

### Mitigation
```solidity
function mint(address to, uint256 value) public onlyOwner {  //  Add access control
    _mint(to, value);
}
```

---

## Challenge 08: Missing Total Supply Update in Burn

### Issue/Bug
**Location:** Line 91 in `burn()` function  
**Severity:** High

The `burn` function doesn't update `_totalSupply`, breaking the supply accounting.

```solidity
function burn(uint256 value) public {
    //@audit-issue no update of totalSupply
    _balances[msg.sender] -= value;
    emit Transfer(msg.sender, address(0), value);
}
```

**Impact:**
- Total supply becomes inaccurate
- Sum of balances doesn't match total supply
- Breaks token accounting invariants

### Mitigation
```solidity
function burn(uint256 value) public {
    _balances[msg.sender] -= value;
    unchecked {
        _totalSupply -= value;  //  Update total supply
    }
    emit Transfer(msg.sender, address(0), value);
}
```

---

## Challenge 09: Unchecked Balance Subtraction

### Issue/Bug
**Location:** Line 68 in `transfer()` function  
**Severity:** Critical

Balance subtraction is wrapped in `unchecked` block, allowing underflow when transferring more than balance.

```solidity
function transfer(address to, uint256 amount) public returns (bool) {
    //@audit-issue unchecked balance if > amount
    unchecked {
        _balances[msg.sender] -= amount;  //  Can underflow!
    }
    _balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
    return true;
}
```

**Impact:**
- Users can transfer more tokens than they have
- Balance underflows to type(uint256).max
- Creates tokens from nothing

### Mitigation
```solidity
function transfer(address to, uint256 amount) public returns (bool) {
    uint256 balance = _balances[msg.sender];
    require(balance >= amount, "ERC20: insufficient balance");  //  Add check
    
    unchecked {
        _balances[msg.sender] = balance - amount;
    }
    _balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
    return true;
}
```

---

## Challenge 10: Broken OnlyOwner Modifier

### Issue/Bug
**Location:** Line 40 in `onlyOwner` modifier  
**Severity:** Critical

The modifier uses comparison operator (`==`) instead of assignment check/require, making it ineffective.

```solidity
modifier onlyOwner() {
    //@audit-issue use of == instead of require() breaks this modifier
    msg.sender == owner;  //  Just compares, doesn't enforce!
    _;
}
```

**Impact:**
- Anyone can call owner-only functions (mint, burn, transferOwnership)
- Complete loss of access control
- Anyone can take ownership of the contract

### Mitigation
```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Caller is not owner");  //  Use require
    _;
}
```

---

## Challenge 11: Incorrect Allowance Update in TransferFrom

### Issue/Bug
**Location:** Line 77 in `transferFrom()` function  
**Severity:** High

The allowance mapping indices are swapped, updating the wrong allowance slot.

```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _transfer(from, to, value);
    uint256 currentAllowance = _allowances[from][msg.sender];
    require(currentAllowance >= value, "Insufficient allowance");
    //@audit-issue incorrect update of allowance
    _allowances[msg.sender][from] = currentAllowance - value;  //  Reversed!
    return true;
}
```

**Impact:**
- Allowance never decrements properly
- Can spend more than approved amount
- Wrong allowance mapping is modified

### Mitigation
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _transfer(from, to, value);
    uint256 currentAllowance = _allowances[from][msg.sender];
    require(currentAllowance >= value, "Insufficient allowance");
    _allowances[from][msg.sender] = currentAllowance - value;  //  Correct indices
    return true;
}
```

---

## Challenge 12: Gift Function Doesn't Update Total Supply

### Issue/Bug
**Location:** Line 64 in `gift()` function  
**Severity:** Critical

The `gift` function mints tokens without updating `totalSupply`.

```solidity
function gift(address to, uint256 amount) public onlyOwner {
    //@audit-issue totalSupply not updated by gift
    balanceOf[to] += amount;
    emit Transfer(address(0), to, amount);
}
```

**Impact:**
- Total supply becomes inaccurate
- Creates tokens without proper accounting
- Sum of balances exceeds total supply

### Mitigation
```solidity
function gift(address to, uint256 amount) public onlyOwner {
    totalSupply += amount;  //  Update total supply
    balanceOf[to] += amount;
    emit Transfer(address(0), to, amount);
}
```

---

## Challenge 13: Reversed Allowance Mapping

### Issue/Bug
**Location:** Line 50 in `approve()` function  
**Severity:** Critical

The allowance mapping indices are reversed in the approve function.

```solidity
function approve(address spender, uint256 amount) public virtual returns (bool) {
    //@audit-issue incorrect approval logic
    allowance[spender][msg.sender] = amount;  //  Should be [msg.sender][spender]
    emit Approval(msg.sender, spender, amount);
    return true;
}
```

**Impact:**
- Approvals are stored in wrong direction
- TransferFrom will fail even with proper approval
- Breaks ERC-20 allowance functionality

### Mitigation
```solidity
function approve(address spender, uint256 amount) public virtual returns (bool) {
    allowance[msg.sender][spender] = amount;  //  Correct order
    emit Approval(msg.sender, spender, amount);
    return true;
}
```

---

## Challenge 14: Inverted Allowance Logic

### Issue/Bug
**Location:** Line 67 in `transferFrom()` function  
**Severity:** Critical

The condition for updating allowance is inverted - it updates when allowance is unlimited instead of when it's limited.

```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];
    //@audit-issue Updates allowance only when it's type(uint256).max
    if (allowed == type(uint256).max) allowance[from][msg.sender] = allowed - amount;  //  Wrong!
    
    balanceOf[from] -= amount;
    balanceOf[to] += amount;
    emit Transfer(from, to, amount);
    return true;
}
```

**Impact:**
- Allowances never decrease for normal approvals
- Can spend unlimited tokens after any approval
- Only decrements the unlimited allowance (which remains effectively unlimited)

### Mitigation
```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];
    
    if (allowed != type(uint256).max) {  //  Correct condition
        require(allowed >= amount, "Insufficient allowance");
        allowance[from][msg.sender] = allowed - amount;
    }
    
    balanceOf[from] -= amount;
    balanceOf[to] += amount;
    emit Transfer(from, to, amount);
    return true;
}
```

---

## Challenge 15: Mint Doesn't Update Balance

### Issue/Bug
**Location:** Line 87 in `_mint()` function  
**Severity:** Critical

The `_mint` function updates total supply but never updates the recipient's balance.

```solidity
function _mint(address to, uint256 amount) internal virtual {
    totalSupply += amount;
    //@audit-issue nothing minted to the address [to]
    emit Transfer(address(0), to, amount);
}
```

**Impact:**
- Minted tokens don't appear in recipient's balance
- Total supply increases but no one receives the tokens
- Tokens are lost forever

### Mitigation
```solidity
function _mint(address to, uint256 amount) internal virtual {
    totalSupply += amount;
    unchecked {
        balanceOf[to] += amount;  //  Update recipient balance
    }
    emit Transfer(address(0), to, amount);
}
```

---

## Challenge 16: Approve Function Doesn't Set Allowance

### Issue/Bug
**Location:** Line 75 in `approve()` function  
**Severity:** Critical

The `approve` function only emits an event but never updates the allowance mapping.

```solidity
function approve(address spender, uint256 value) public returns (bool) {
    //@audit-issue nothing approved, _approve() call is commented out
    //_approve(msg.sender, spender, value);
    emit Approval(msg.sender, spender, value);  //  Only emits event!
    return true;
}
```

**Impact:**
- Approvals don't actually set allowances
- TransferFrom always fails
- Complete breakdown of allowance system

### Mitigation
```solidity
function approve(address spender, uint256 value) public returns (bool) {
    _approve(msg.sender, spender, value);  //  Actually set the allowance
    return true;
}
```

---

## Challenge 17: Checks Wrong Balance in Transfer

### Issue/Bug
**Location:** Line 98 in `_transfer()` function  
**Severity:** Critical

The transfer function checks the recipient's balance instead of sender's balance, and uses recipient's balance for sender's deduction.

```solidity
function _transfer(address from, address to, uint256 value) internal {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

    //@audit-issue Checks recipient's balance instead of sender's
    uint256 toBalance = _balances[to];
    require(toBalance >= value, "ERC20: transfer amount exceeds balance");

    _balances[from] = toBalance - value;  //  Uses recipient's balance!
    _balances[to] += value;

    emit Transfer(from, to, value);
}
```

**Impact:**
- Transfers fail if recipient has insufficient balance (even if sender has enough)
- Sender's balance gets set to recipient's balance minus transfer amount
- Completely corrupts balances

### Mitigation
```solidity
function _transfer(address from, address to, uint256 value) internal {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

    uint256 fromBalance = _balances[from];  //  Check sender's balance
    require(fromBalance >= value, "ERC20: transfer amount exceeds balance");

    _balances[from] = fromBalance - value;  //  Use sender's balance
    _balances[to] += value;

    emit Transfer(from, to, value);
}
```

---

## Challenge 18: Mint Doesn't Update Total Supply

### Issue/Bug
**Location:** Line 119 in `_mint()` function  
**Severity:** High

The `_mint` function updates balances but doesn't update the total supply.

```solidity
function _mint(address account, uint256 value) internal {
    require(account != address(0), "ERC20: mint to the zero address");
    //@audit-issue total supply not updated after minting
    unchecked {
        _balances[account] += value;
    }
    emit Transfer(address(0), account, value);
}
```

**Impact:**
- Total supply remains at 0 while balances increase
- Sum of balances exceeds reported total supply
- Breaks token accounting invariants

### Mitigation
```solidity
function _mint(address account, uint256 value) internal {
    require(account != address(0), "ERC20: mint to the zero address");
    
    _totalSupply += value;  //  Update total supply
    unchecked {
        _balances[account] += value;
    }
    emit Transfer(address(0), account, value);
}
```

---

## Challenge 19: Hook Before Balance Check

### Issue/Bug
**Location:** Line 105 in `_transfer()` function  
**Severity:** Critical

The `_beforeTokenTransfer` hook is called before the balance check, allowing derived contracts to manipulate state.

```solidity
function _transfer(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

    uint256 fromBalance = _balances[from];
    uint256 toBalance = _balances[to];
    
    //@audit-issue Hook called BEFORE balance check
    _beforeTokenTransfer(from, to, amount);  //  Can manipulate state!

    require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
    
    unchecked {
        _balances[from] = fromBalance - amount;
        _balances[to] = toBalance + amount;
    }

    emit Transfer(from, to, amount);
    _afterTokenTransfer(from, to, amount);
}
```

**Impact:**
- Malicious derived contracts can inflate sender's balance in the hook
- Bypasses balance validation
- Can create tokens from nothing
- Breaks total supply invariant

### Mitigation
```solidity
function _transfer(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

    uint256 fromBalance = _balances[from];
    require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");  //  Check first
    
    _beforeTokenTransfer(from, to, amount);  //  Then call hook
    
    unchecked {
        _balances[from] = fromBalance - amount;
        _balances[to] += amount;
    }

    emit Transfer(from, to, amount);
    _afterTokenTransfer(from, to, amount);
}
```

---

## Challenge 20: Allowance Increases Instead of Decreases

### Issue/Bug
**Location:** Line 68 in `transferFrom()` function  
**Severity:** Critical

The allowance is incremented instead of decremented when tokens are spent.

```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];

    //@audit-issue Adds to allowance instead of subtracting
    if (allowed != type(uint256).max) 
        allowance[from][msg.sender] = allowed + amount;  //  Should subtract!

    balanceOf[from] -= amount;
    balanceOf[to] += amount;

    emit Transfer(from, to, amount);
    return true;
}
```

**Impact:**
- Every transfer increases allowance instead of decreasing it
- Can spend unlimited tokens after initial approval
- Completely breaks allowance system

### Mitigation
```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];

    if (allowed != type(uint256).max) {
        require(allowed >= amount, "Insufficient allowance");  //  Check first
        allowance[from][msg.sender] = allowed - amount;  //  Subtract amount
    }

    balanceOf[from] -= amount;
    balanceOf[to] += amount;

    emit Transfer(from, to, amount);
    return true;
}
```