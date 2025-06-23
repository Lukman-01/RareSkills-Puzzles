# RareSkills Puzzle Solutions

Welcome to the **RareSkills Puzzle Solutions Repository** a curated collection of solutions to coding puzzles from the [RareSkills](https://www.rareskills.io) platform. These puzzles span various technologies including smart contract security, gas optimization, zero-knowledge proofs, and low-level EVM logic.

Whether you're aiming to sharpen your skills in Solidity, Huff, Yul, or Noir, this repository provides structured challenges that promote deeper understanding through hands-on learning.


## 📌 Important Note

> This repository contains **only the solutions** to the RareSkills puzzles.  
> **Puzzle prompts and questions are not included** here.

To get the full learning experience:
1. Visit the official [RareSkills](https://www.rareskills.io) site or their respective public GitHub repositories.
2. Attempt the puzzles on your own.
3. Return here to compare your solution or gain insight into alternative approaches.


## 🎯 Why Puzzles?

While building full projects is valuable, puzzles offer focused practice with immediate feedback. They:

- Encourage exploration of unfamiliar concepts.
- Strengthen problem-solving and debugging skills.
- Provide digestible, time-efficient challenges.
- Help you think more like a security auditor or protocol engineer.


## 🧩 Puzzle Categories

Each folder in this repository corresponds to a different category of puzzles:

### 🔹 Solidity-Based

- **Solidity Exercises**  
  Beginner-friendly drills for learning Solidity basics and syntax.

- **Solidity Riddles**  
  18 CTF-style puzzles centered around identifying and exploiting smart contract vulnerabilities.

- **Gas Optimization Puzzles**  
  Write gas-efficient Solidity code that meets strict gas usage requirements.

- **Uniswap V2 Puzzles**  
  Deep dive into the internal mechanics of Uniswap V2 through hands-on exercises.

### 🔹 Low-Level & Assembly

- **Huff Puzzles**  
  Build logic using the Huff programming language, working directly with EVM opcodes.

- **Yul Puzzles**  
  A comprehensive set of 80+ assembly-based challenges using the Yul language. Write code to pass tests in pure Yul.

### 🔹 Zero-Knowledge Proofs

- **ZK Puzzles (Circom)**  
  Learn zero-knowledge circuit design by implementing puzzles in Circom.

- **Noir Puzzles**  
  Write zero-knowledge circuits using the Noir DSL. Includes both standalone puzzles and puzzles integrated with Foundry tests.

### 🔹 Auditing & Security Analysis

- **Buggy ERC-20**  
  A collection of 20 intentionally broken ERC-20 token implementations. Analyze and identify critical bugs that deviate from the ERC-20 standard. Inspired by real-world token vulnerabilities.


## 🚀 Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Lukman-01/RareSkills-Puzzles.git
   cd RareSkills-Puzzles
````

2. **Pick a Puzzle Folder**
   Navigate to any of the puzzle categories above (e.g., `solidity-riddles`, `yul-puzzles`, `zk-puzzles`, etc.).

3. **Attempt the Puzzle First**
   Refer to the original puzzle prompt from RareSkills before checking the solution.

4. **Test Your Solution**
   Most folders include test files. Use the appropriate toolchain:

   * `forge test` (with Foundry) for Solidity, Huff, or Yul.
   * `nargo test` for Noir.
   * Circom uses `snarkjs` or `circom` directly depending on the setup.


## 🧠 How to Approach Each Puzzle

* **Understand the Problem**: Start by studying the puzzle description from the RareSkills source.
* **Work Independently**: Attempt solving it on your own.
* **Compare and Learn**: Review the solution in this repo to see different patterns, optimizations, or missed edge cases.
* **Explore Alternatives**: Consider writing your own optimized or more secure version.