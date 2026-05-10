#!/bin/bash
# 💰 Immunefi Target & Bounty List Generator
# Creates curated list of Immunefi programs with bounty info

OUTPUT_FILE=~/bugbounty/targets/immunefi_targets.txt
BOUNTY_FILE=~/bugbounty/targets/immunefi_bounty_list.txt

echo "💰 === IMMUNEFI BOUNTY TARGET GENERATOR ==="
echo ""

mkdir -p ~/bugbounty/targets

# High-value Web3 targets with known bug bounty programs
cat > $OUTPUT_FILE << 'TARGETS'
# Immunefi Bug Bounty Targets
# Focus: Web3, DeFi, Smart Contracts, Infrastructure

# === TOP TIER (Highest Payouts $1M-$10M) ===
aave.com
compound.finance
makerdao.com
uniswap.org
curve.fi
lido.fi
rocketpool.net
synthetix.io

# === MID TIER ($100K-$1M) ===
balancer.fi
yearn.finance
sushi.com
pancakeswap.finance
opensea.io
blur.io
arbitrum.io
optimism.io
polygon.technology
avalabs.org
near.org
solana.com
cosmos.network
ens.domains

# === WEB3 INFRASTRUCTURE ($50K-$500K) ===
metamask.io
walletconnect.com
infura.io
alchemy.com
quicknode.com
phantom.app
jup.ag
raydium.io
orca.so
marinade.finance
magic-eden.io
tensor.trade

# === CEX/EXCHANGES ($50K-$500K) ===
binance.com
coinbase.com
kraken.com
kucoin.com
gate.io
bybit.com
okx.com

# === DEFI PROTOCOLS ($10K-$100K) ===
euler.finance
notional.finance
liquity.org
reflexer.finance
alchemix.fi

# === IMMUNEFI PLATFORM ===
immunefi.com
code4rena.com
sherlock.xyz
hackenproof.com
TARGETS

# Create bounty reference list
cat > $BOUNTY_FILE << 'BOUNTIES'
# 💰 Immunefi Bounty Reference List
# Source: https://immunefi.com/explore/

## TOP TIER PROGRAMS ($1M - $10M+)
| Program | Max Bounty | Focus | Targets |
|---------|-----------|-------|---------|
| **Aave** | $10,000,000 | Lending Protocol | aave.com, app.aave.com |
| **Compound** | $5,000,000 | Lending Protocol | compound.finance, app.compound.finance |
| **MakerDAO** | $10,000,000 | Stablecoin | makerdao.com, oasis.app |
| **Uniswap** | $5,000,000 | DEX | uniswap.org, app.uniswap.org |
| **Curve** | $5,000,000 | DEX | curve.fi |
| **Lido** | $10,000,000 | Liquid Staking | lido.fi |
| **Rocket Pool** | $2,000,000 | Liquid Staking | rocketpool.net |
| **Synthetix** | $5,000,000 | Derivatives | synthetix.io |

## MID TIER PROGRAMS ($100K - $1M)
| Program | Max Bounty | Focus | Targets |
|---------|-----------|-------|---------|
| **Balancer** | $1,000,000 | DEX | balancer.fi |
| **Yearn Finance** | $1,000,000 | Yield Aggregator | yearn.finance |
| **SushiSwap** | $500,000 | DEX | sushi.com |
| **PancakeSwap** | $1,000,000 | DEX (BSC) | pancakeswap.finance |
| **OpenSea** | $500,000 | NFT Marketplace | opensea.io |
| **Blur** | $500,000 | NFT Marketplace | blur.io |
| **Arbitrum** | $5,000,000 | L2 Scaling | arbitrum.io |
| **Optimism** | $2,000,000 | L2 Scaling | optimism.io |
| **Polygon** | $2,000,000 | L2 Scaling | polygon.technology |
| **Avalanche** | $1,000,000 | L1 Blockchain | avalabs.org |
| **NEAR** | $1,000,000 | L1 Blockchain | near.org |
| **Solana** | $5,000,000 | L1 Blockchain | solana.com |
| **ENS** | $500,000 | Naming Service | ens.domains |

## WEB3 INFRASTRUCTURE ($50K - $500K)
| Program | Max Bounty | Focus | Targets |
|---------|-----------|-------|---------|
| **MetaMask** | $500,000 | Wallet | metamask.io |
| **WalletConnect** | $250,000 | Wallet Connect | walletconnect.com |
| **Infura** | $250,000 | Node Provider | infura.io |
| **Alchemy** | $250,000 | Node Provider | alchemy.com |
| **Phantom** | $500,000 | Wallet | phantom.app |
| **Jupiter** | $250,000 | DEX Aggregator | jup.ag |
| **Raydium** | $250,000 | DEX (Solana) | raydium.io |

## CEX/EXCHANGES ($50K - $500K)
| Program | Max Bounty | Focus | Targets |
|---------|-----------|-------|---------|
| **Binance** | $500,000 | Exchange | binance.com |
| **Coinbase** | $500,000 | Exchange | coinbase.com |
| **Kraken** | $250,000 | Exchange | kraken.com |
| **KuCoin** | $250,000 | Exchange | kucoin.com |
| **Bybit** | $250,000 | Exchange | bybit.com |

## DEFI PROTOCOLS ($10K - $100K)
| Program | Max Bounty | Focus | Targets |
|---------|-----------|-------|---------|
| **Euler** | $1,000,000 | Lending | euler.finance |
| **Notional** | $500,000 | Fixed Rate | notional.finance |
| **Liquity** | $500,000 | Borrowing | liquity.org |

## EASIEST BUG TYPES FOR IMMUNEFI (Non-Smart Contract)

### 1. Website/Infrastructure Bugs
- **XSS on dApps** → $5,000-$50,000
- **Auth bypass on dashboards** → $10,000-$100,000
- **API manipulation** → $5,000-$50,000
- **SQLi on web interfaces** → $25,000-$250,000
- **Subdomain takeover** → $5,000-$50,000

### 2. Wallet Integration Bugs
- **Signature manipulation** → $50,000-$500,000
- **Transaction replay attacks** → $100,000-$1M
- **Front-running vulnerabilities** → $50,000-$500,000

### 3. Smart Contract Bugs (Highest Payouts)
- **Reentrancy** → $100,000-$10M
- **Flash loan attacks** → $100,000-$10M
- **Logic errors** → $50,000-$5M
- **Access control bugs** → $50,000-$5M

## 🎯 BEGINNER-FRIENDLY IMMUNEFI TARGETS

### Start Here (Easier, Less Competition):
1. **Smaller DeFi protocols** ($10K-$100K bounties)
   - Less scrutinized than Aave/Uniswap
   - Euler, Notional, Liquity
   
2. **Web3 infrastructure** ($50K-$250K)
   - Website bugs on node providers
   - API issues on wallets
   
3. **Newer protocols** (recently launched)
   - Less auditing done
   - More likely to have bugs

### Avoid Initially:
- Aave, Uniswap, MakerDAO (heavily audited)
- Complex smart contract logic (requires Solidity expertise)
- Core protocol bugs (very difficult)

## 💡 STRATEGY FOR FIRST IMMUNEFI BOUNTY

### Week 1-2: Reconnaissance
1. Pick 3-5 mid-tier programs
2. Map all web interfaces
3. Test for: XSS, Auth bypass, API bugs
4. Look for: Subdomain takeover, info leaks

### Week 3-4: Deep Testing
1. Focus on ONE program
2. Test wallet integration flows
3. Look for transaction manipulation
4. Check for signature verification issues

### Month 2+: Smart Contracts
1. Learn Solidity basics
2. Use automated tools (Slither, Mythril)
3. Focus on logic errors
4. Look for missing access controls

## 📊 IMMUNEFI VS TRADITIONAL PLATFORMS

| Factor | Immunefi | HackerOne |
|--------|----------|-----------|
| Avg Bounty | $50K+ | $500+ |
| Competition | LOW | HIGH |
| Technical Difficulty | HIGH | MEDIUM |
| Payout Speed | Fast | Medium |
| Payment | Crypto (USDC) | PayPal/Bank |
| Smart Contract Needed | Optional | No |
| First Bounty Timeline | 30-60 days | 60-90 days |

## 🔗 IMPORTANT LINKS

- Immunefi Homepage: https://immunefi.com/
- Browse Bounties: https://immunefi.com/explore/
- Documentation: https://immunefi.com/learn/
- Discord: https://discord.gg/immunefi
- Bug Writing Guide: https://immunefi.com/learn/how-to-write-a-good-report/
BOUNTIES

echo "✅ Immunefi targets created:"
echo "   Targets: $OUTPUT_FILE ($(wc -l < $OUTPUT_FILE) lines)"
echo "   Bounty List: $BOUNTY_FILE ($(wc -l < $BOUNTY_FILE) lines)"
echo ""
echo "📊 Summary:"
echo "   - $(grep -c '^#' $OUTPUT_FILE) target categories"
echo "   - $(grep -v '^#' $OUTPUT_FILE | grep -v '^$' | wc -l) total targets"
echo ""
echo "🎯 Top 10 Targets for Beginners:"
echo "   1. euler.finance ($1M max bounty)"
echo "   2. notional.finance ($500K max bounty)"
echo "   3. liquity.org ($500K max bounty)"
echo "   4. metamask.io ($500K max bounty)"
echo "   5. phantom.app ($500K max bounty)"
echo "   6. jup.ag ($250K max bounty)"
echo "   7. raydium.io ($250K max bounty)"
echo "   8. walletconnect.com ($250K max bounty)"
echo "   9. infura.io ($250K max bounty)"
echo "   10. alchemy.com ($250K max bounty)"
