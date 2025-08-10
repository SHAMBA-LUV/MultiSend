#!/bin/bash

# =============================================================================
# MultiSend Contract Deployment & Verification Script (Polygon)
# =============================================================================
# - Deploys MultiSend (no constructor args)
# - Verifies on PolygonScan via forge
# - Saves deployment info & creates a reusable verify script
# =============================================================================

set -e

# =============================================================================
# CONFIGURATION
# =============================================================================

# Load environment variables
if [ -f .env ]; then
  source .env
  echo "✅ .env file loaded"
else
  echo "❌ .env file not found! Please create .env with PRIVATE_KEY and ETHERSCAN_API_KEY"
  exit 1
fi

CONTRACT_NAME="MultiSend"
CONTRACT_FILE="contracts/multisend/MultiSend.sol"
CHAIN_ID=137
RPC_URL="https://polygon-rpc.com"

# Compiler/verify settings (match deployment)
COMPILER_VERSION="v0.8.30+commit.8d039335"
OPTIMIZER_RUNS=0

# =============================================================================
# VALIDATION
# =============================================================================

echo "🔍 Validating configuration..."

if [ -z "$PRIVATE_KEY" ]; then
  echo "❌ PRIVATE_KEY not set in .env"
  exit 1
fi

if [ -z "$ETHERSCAN_API_KEY" ]; then
  echo "❌ ETHERSCAN_API_KEY not set in .env"
  exit 1
fi

if [ ! -f "$CONTRACT_FILE" ]; then
  echo "❌ Contract file not found: $CONTRACT_FILE"
  exit 1
fi

echo "✅ Validation passed"

# =============================================================================
# SUMMARY & CONFIRM
# =============================================================================

echo ""
echo "🚀 MultiSend Contract Deployment"
echo "================================"
echo "Network: Polygon Mainnet"
echo "Contract: $CONTRACT_NAME"
echo "File: $CONTRACT_FILE"
echo "Chain ID: $CHAIN_ID"
echo "Compiler: $COMPILER_VERSION"
echo "Optimizer runs: $OPTIMIZER_RUNS"
echo ""

read -p "Proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Deployment cancelled"
  exit 0
fi

# =============================================================================
# BUILD
# =============================================================================

echo "📦 Building contracts..."
forge build --force
echo "✅ Build complete"

# =============================================================================
# DEPLOY
# =============================================================================

echo "🚀 Deploying $CONTRACT_NAME..."
DEPLOY_OUTPUT=$(forge create \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --chain-id "$CHAIN_ID" \
  --broadcast \
  "$CONTRACT_FILE:$CONTRACT_NAME")

CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -o "Deployed to: 0x[a-fA-F0-9]*" | cut -d' ' -f3)
if [ -z "$CONTRACT_ADDRESS" ]; then
  echo "❌ Failed to extract contract address"
  echo "$DEPLOY_OUTPUT"
  exit 1
fi

echo "✅ Deployed at: $CONTRACT_ADDRESS"

# =============================================================================
# SAVE DEPLOYMENT INFO
# =============================================================================

mkdir -p contracts/multisend
cat > contracts/multisend/deployment-info.txt << EOF
# MultiSend Deployment Info
# =========================
Date: $(date -u)
Network: Polygon Mainnet
Chain ID: $CHAIN_ID

Contract: $CONTRACT_NAME
Address: $CONTRACT_ADDRESS
File: $CONTRACT_FILE

Compiler: $COMPILER_VERSION
Optimizer Runs: $OPTIMIZER_RUNS
Constructor Args: (none)

Explorer: https://polygonscan.com/address/$CONTRACT_ADDRESS
EOF

echo "✅ Saved: contracts/multisend/deployment-info.txt"

# =============================================================================
# CREATE VERIFY SCRIPT
# =============================================================================

cat > contracts/multisend/verify-multisend.sh << EOF
#!/bin/bash
set -e

source .env

CONTRACT_ADDRESS="$CONTRACT_ADDRESS"
CONTRACT_FILE="$CONTRACT_FILE"
CONTRACT_NAME="$CONTRACT_NAME"
CHAIN_ID=$CHAIN_ID
COMPILER_VERSION="$COMPILER_VERSION"
OPTIMIZER_RUNS=$OPTIMIZER_RUNS

echo "🔧 Verifying MultiSend on PolygonScan"
echo "Address: \$CONTRACT_ADDRESS"

forge verify-contract \
  "\$CONTRACT_ADDRESS" \
  "\$CONTRACT_FILE:\$CONTRACT_NAME" \
  --chain-id \$CHAIN_ID \
  --etherscan-api-key "\$ETHERSCAN_API_KEY" \
  --compiler-version "\$COMPILER_VERSION" \
  --optimizer-runs \$OPTIMIZER_RUNS
EOF

chmod +x contracts/multisend/verify-multisend.sh
echo "✅ Created: contracts/multisend/verify-multisend.sh"

# =============================================================================
# VERIFY NOW
# =============================================================================

echo ""
echo "🔧 Submitting verification..."
VERIFY_OUTPUT=$(contracts/multisend/verify-multisend.sh || true)
echo "$VERIFY_OUTPUT"

echo ""
echo "🎉 Done. Contract: $CONTRACT_ADDRESS"
echo "🔗 https://polygonscan.com/address/$CONTRACT_ADDRESS"


