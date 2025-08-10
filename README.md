# MultiSend Contract

https://polygonscan.com/address/0xde55b9c14b1a355aef70787667713560c76cd5f9#code

A gas-efficient multisend smart contract for Polygon that can hold and distribute both native MATIC and any ERC20 tokens to multiple addresses.

## Features

- **Gas Efficient**: Optimized for batch transfers with configurable max batch size
- **Multi-Token Support**: Send any ERC20 token or native MATIC
- **Flexible Distribution**: Variable amounts, uniform amounts, default amounts, or equal splits
- **Security**: Uses OpenZeppelin's `Ownable2Step`, `ReentrancyGuard`, and `Pausable`
- **Recovery Functions**: Recover stuck tokens and native MATIC

## Contract Address

- **Network**: Polygon Mainnet
- **Address**: `0xDe55B9C14B1a355AEF70787667713560C76cd5f9`
- **Explorer**: https://polygonscan.com/address/0xDe55B9C14B1a355AEF70787667713560C76cd5f9

## Compiler Settings

- **Solidity**: v0.8.30
- **Optimizer**: Disabled (runs: 0)

## Functions

### ERC20 Multisend
- `multiSendERC20()` - Send variable amounts to multiple addresses
- `multiSendERC20Uniform()` - Send same amount to multiple addresses
- `multiSendERC20UsingDefault()` - Send using pre-set default amount
- `multiSendERC20EqualSplit()` - Split total amount equally among recipients

### Native MATIC Multisend
- `multiSendNative()` - Send variable amounts to multiple addresses
- `multiSendNativeUniform()` - Send same amount to multiple addresses
- `multiSendNativeEqualSplit()` - Split total amount equally among recipients

### Admin Functions
- `setMaxBatchSize()` - Configure maximum batch size
- `setDefaultERC20Amount()` - Set default amount for specific token
- `pause()` / `unpause()` - Emergency pause functionality
- `withdrawERC20()` / `withdrawNative()` - Partial withdrawals
- `recoverStuckERC20()` / `recoverStuckNative()` - Full balance recovery

## Setup

1. Clone the repository
2. Copy `.env.example` to `.env` and fill in your values
3. Install dependencies: `forge install OpenZeppelin/openzeppelin-contracts@v5.0.2`
4. Build: `forge build`
5. Deploy: `./deploy_multisend.sh`

## License

created for SHAMBA LUV (c) 2025 unlicenced and released to the community at large under MultiSend (c) 2025 MIT license<br /><br />
<a href="https://youtu.be/9QqEoem7Vfs?si=d-1pesK7lm7KDWI6">Don’t Work for Money. Command It | Machiavelli’s Law of Power</a>
