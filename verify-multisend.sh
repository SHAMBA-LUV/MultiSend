#!/bin/bash
set -e

source .env

CONTRACT_ADDRESS="0xDe55B9C14B1a355AEF70787667713560C76cd5f9"
CONTRACT_FILE="contracts/multisend/MultiSend.sol"
CONTRACT_NAME="MultiSend"
CHAIN_ID=137
COMPILER_VERSION="v0.8.23+commit.f704f362"
OPTIMIZER_RUNS=0

echo "🔧 Verifying MultiSend on PolygonScan"
echo "Address: $CONTRACT_ADDRESS"

forge verify-contract   "$CONTRACT_ADDRESS"   "$CONTRACT_FILE:$CONTRACT_NAME"   --chain-id $CHAIN_ID   --etherscan-api-key "$ETHERSCAN_API_KEY"   --compiler-version "$COMPILER_VERSION"   --optimizer-runs $OPTIMIZER_RUNS
