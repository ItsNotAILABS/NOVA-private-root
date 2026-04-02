// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: FORMATokenEconomics — Complete Token Economics Dashboard
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Full tokenomics visualization:
//   - FORMA token distribution
//   - Staking mechanics
//   - Rewards calculation
//   - Burn mechanisms
//   - Liquidity pools
//   - Price oracle
//   - Treasury management
// ============================================================================

import React, { useState, useMemo } from 'react';

const φ = 1.6180339887498948482;

// ─── TOKEN METRICS ────────────────────────────────────────────────────────────
const TOKEN_CONFIG = {
  name: 'FORMA',
  symbol: 'FORMA',
  decimals: 8,
  maxSupply: 1_000_000_000_000, // 1 trillion
  initialPrice: 0.001, // USD
};

// ─── DISTRIBUTION CATEGORIES ──────────────────────────────────────────────────
const DISTRIBUTION = [
  { name: 'Ecosystem Rewards', percentage: 40, color: '#00ff88', locked: false },
  { name: 'Team & Advisors', percentage: 15, color: '#4488ff', locked: true, vestingMonths: 48 },
  { name: 'Treasury', percentage: 20, color: '#ffd700', locked: true },
  { name: 'Community Sale', percentage: 10, color: '#aa44ff', locked: false },
  { name: 'Liquidity', percentage: 10, color: '#ff8800', locked: true, vestingMonths: 12 },
  { name: 'Creator Reserve', percentage: 5, color: '#ff4488', locked: true, vestingMonths: 48 },
];

// ─── PIE CHART ────────────────────────────────────────────────────────────────
function DistributionPieChart({ distribution }) {
  const total = distribution.reduce((s, d) => s + d.percentage, 0);
  let currentAngle = 0;
  
  return (
    <svg width="200" height="200" viewBox="-1 -1 2 2" style={{ transform: 'rotate(-90deg)' }}>
      {distribution.map((segment, i) => {
        const angle = (segment.percentage / total) * 2 * Math.PI;
        const x1 = Math.cos(currentAngle);
        const y1 = Math.sin(currentAngle);
        const x2 = Math.cos(currentAngle + angle);
        const y2 = Math.sin(currentAngle + angle);
        const largeArc = angle > Math.PI ? 1 : 0;
        
        const path = `M 0 0 L ${x1} ${y1} A 1 1 0 ${largeArc} 1 ${x2} ${y2} Z`;
        currentAngle += angle;
        
        return (
          <path
            key={segment.name}
            d={path}
            fill={segment.color}
            opacity={0.8}
            stroke="#070e1e"
            strokeWidth="0.02"
          />
        );
      })}
      <circle r="0.5" fill="#070e1e" />
    </svg>
  );
}

// ─── TOKEN SUPPLY DISPLAY ─────────────────────────────────────────────────────
function TokenSupply({ supply }) {
  const burnPercentage = ((supply.burned / supply.total) * 100).toFixed(2);
  const circulatingPercentage = ((supply.circulating / supply.total) * 100).toFixed(2);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ffd700',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ffd700', marginBottom: 8 }}>💰 TOKEN SUPPLY</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 12, marginBottom: 12 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Total Supply</div>
          <div style={{ fontSize: 14, color: '#ffd700' }}>
            {formatNumber(supply.total)}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Circulating</div>
          <div style={{ fontSize: 14, color: '#00ff88' }}>
            {formatNumber(supply.circulating)}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Staked</div>
          <div style={{ fontSize: 14, color: '#4488ff' }}>
            {formatNumber(supply.staked)}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Burned 🔥</div>
          <div style={{ fontSize: 14, color: '#ff4444' }}>
            {formatNumber(supply.burned)}
          </div>
        </div>
      </div>
      
      {/* Supply bar */}
      <div style={{
        height: 12,
        background: '#050a14',
        borderRadius: 6,
        overflow: 'hidden',
        display: 'flex',
      }}>
        <div style={{
          width: `${circulatingPercentage}%`,
          background: '#00ff88',
        }} title={`Circulating: ${circulatingPercentage}%`} />
        <div style={{
          width: `${(supply.staked / supply.total) * 100}%`,
          background: '#4488ff',
        }} title="Staked" />
        <div style={{
          width: `${burnPercentage}%`,
          background: '#ff4444',
        }} title={`Burned: ${burnPercentage}%`} />
      </div>
      
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 7, color: '#68a', marginTop: 4 }}>
        <span>Circulating: {circulatingPercentage}%</span>
        <span>Burned: {burnPercentage}%</span>
      </div>
    </div>
  );
}

// ─── PRICE ORACLE ─────────────────────────────────────────────────────────────
function PriceOracle({ price, history }) {
  const change24h = ((price.current - price.yesterday) / price.yesterday) * 100;
  const isUp = change24h >= 0;
  const maxPrice = Math.max(...history.map(h => h.price));
  const minPrice = Math.min(...history.map(h => h.price));
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${isUp ? '#00ff88' : '#ff4444'}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#6af', marginBottom: 8 }}>📊 PRICE ORACLE</div>
      
      <div style={{ display: 'flex', alignItems: 'flex-end', gap: 8, marginBottom: 12 }}>
        <div style={{ fontSize: 24, color: '#ffd700', fontWeight: 'bold' }}>
          ${price.current.toFixed(6)}
        </div>
        <div style={{
          fontSize: 12,
          color: isUp ? '#00ff88' : '#ff4444',
          display: 'flex',
          alignItems: 'center',
          gap: 2,
        }}>
          {isUp ? '▲' : '▼'} {Math.abs(change24h).toFixed(2)}%
        </div>
      </div>
      
      {/* Price chart */}
      <div style={{
        height: 60,
        display: 'flex',
        alignItems: 'flex-end',
        gap: 1,
        padding: 4,
        background: '#050a14',
        borderRadius: 4,
      }}>
        {history.map((h, i) => {
          const height = ((h.price - minPrice) / (maxPrice - minPrice)) * 100;
          return (
            <div
              key={i}
              style={{
                flex: 1,
                height: `${height}%`,
                background: h.price >= (history[i - 1]?.price || h.price) ? '#00ff88' : '#ff4444',
                borderRadius: '2px 2px 0 0',
                minHeight: 2,
              }}
              title={`$${h.price.toFixed(6)}`}
            />
          );
        })}
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginTop: 8 }}>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>24h High</div>
          <div style={{ fontSize: 10, color: '#00ff88' }}>${price.high24h.toFixed(6)}</div>
        </div>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>24h Low</div>
          <div style={{ fontSize: 10, color: '#ff4444' }}>${price.low24h.toFixed(6)}</div>
        </div>
        <div>
          <div style={{ fontSize: 7, color: '#68a' }}>Market Cap</div>
          <div style={{ fontSize: 10, color: '#ffd700' }}>${formatNumber(price.marketCap)}</div>
        </div>
      </div>
    </div>
  );
}

// ─── STAKING PANEL ────────────────────────────────────────────────────────────
function StakingPanel({ staking }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #4488ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#4488ff', marginBottom: 8 }}>🔒 STAKING</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 12, marginBottom: 12 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Total Staked</div>
          <div style={{ fontSize: 16, color: '#4488ff' }}>
            {formatNumber(staking.totalStaked)}
          </div>
          <div style={{ fontSize: 8, color: '#68a' }}>
            ({staking.stakingRatio.toFixed(1)}% of supply)
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>APY</div>
          <div style={{ fontSize: 24, color: '#00ff88' }}>
            {staking.apy.toFixed(2)}%
          </div>
        </div>
      </div>
      
      {/* Staking tiers */}
      <div style={{ fontSize: 9, color: '#6af', marginBottom: 6 }}>STAKING TIERS</div>
      {staking.tiers.map(tier => (
        <div key={tier.name} style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '6px 0',
          borderBottom: '1px solid #1a3a5c',
        }}>
          <div>
            <div style={{ fontSize: 9, color: tier.color }}>{tier.name}</div>
            <div style={{ fontSize: 7, color: '#68a' }}>Min: {formatNumber(tier.minStake)}</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 10, color: '#00ff88' }}>{tier.apy}% APY</div>
            <div style={{ fontSize: 7, color: '#68a' }}>{tier.lockPeriod}</div>
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── TREASURY ─────────────────────────────────────────────────────────────────
function Treasury({ treasury }) {
  const totalValue = treasury.holdings.reduce((s, h) => s + h.valueUsd, 0);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #aa44ff',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#aa44ff', marginBottom: 8 }}>🏦 TREASURY</div>
      
      <div style={{ fontSize: 20, color: '#ffd700', marginBottom: 12 }}>
        ${formatNumber(totalValue)}
      </div>
      
      {treasury.holdings.map(holding => (
        <div key={holding.asset} style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '6px 0',
          borderBottom: '1px solid #1a3a5c',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <span style={{ fontSize: 14 }}>{holding.icon}</span>
            <span style={{ fontSize: 9, color: '#adf' }}>{holding.asset}</span>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 9, color: '#4af' }}>{formatNumber(holding.amount)}</div>
            <div style={{ fontSize: 7, color: '#68a' }}>${formatNumber(holding.valueUsd)}</div>
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── BURN TRACKER ─────────────────────────────────────────────────────────────
function BurnTracker({ burns }) {
  const totalBurned = burns.reduce((s, b) => s + b.amount, 0);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff4444',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <span style={{ fontSize: 16 }}>🔥</span>
        <div style={{ fontSize: 10, color: '#ff4444' }}>BURN TRACKER</div>
      </div>
      
      <div style={{ fontSize: 18, color: '#ff4444', marginBottom: 8 }}>
        {formatNumber(totalBurned)} FORMA
      </div>
      
      <div style={{ maxHeight: 100, overflow: 'auto' }}>
        {burns.slice(-5).reverse().map((burn, i) => (
          <div key={i} style={{
            display: 'flex',
            justifyContent: 'space-between',
            padding: '4px 0',
            borderBottom: '1px solid #1a3a5c',
            fontSize: 8,
          }}>
            <span style={{ color: '#68a' }}>{burn.date}</span>
            <span style={{ color: '#ff4444' }}>-{formatNumber(burn.amount)}</span>
            <span style={{ color: '#adf' }}>{burn.reason}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── LIQUIDITY POOLS ──────────────────────────────────────────────────────────
function LiquidityPools({ pools }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ff8800',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ff8800', marginBottom: 8 }}>💧 LIQUIDITY POOLS</div>
      
      {pools.map(pool => (
        <div key={pool.pair} style={{
          padding: 8,
          marginBottom: 6,
          borderRadius: 6,
          background: '#050a14',
          border: '1px solid #1a3a5c',
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
            <span style={{ fontSize: 10, color: '#adf' }}>{pool.pair}</span>
            <span style={{ fontSize: 9, color: '#00ff88' }}>{pool.apy}% APY</span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 8 }}>
            <div>
              <div style={{ fontSize: 7, color: '#68a' }}>TVL</div>
              <div style={{ fontSize: 9, color: '#ffd700' }}>${formatNumber(pool.tvl)}</div>
            </div>
            <div>
              <div style={{ fontSize: 7, color: '#68a' }}>Volume 24h</div>
              <div style={{ fontSize: 9, color: '#4af' }}>${formatNumber(pool.volume24h)}</div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── UTILITY ──────────────────────────────────────────────────────────────────
function formatNumber(num) {
  if (num >= 1e12) return (num / 1e12).toFixed(2) + 'T';
  if (num >= 1e9) return (num / 1e9).toFixed(2) + 'B';
  if (num >= 1e6) return (num / 1e6).toFixed(2) + 'M';
  if (num >= 1e3) return (num / 1e3).toFixed(2) + 'K';
  return num.toFixed(2);
}

// ─── STYLES ───────────────────────────────────────────────────────────────────
const styles = {
  root: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    borderRadius: 4,
    overflow: 'hidden',
  },
  header: {
    padding: '10px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 12,
    color: '#ffd700',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 10,
    padding: 10,
    overflow: 'auto',
  },
  distributionPanel: {
    background: '#0a1a2e',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
    padding: 12,
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function FORMATokenEconomics({ tokenState = {} }) {
  // Sample state if none provided
  const state = {
    supply: tokenState.supply || {
      total: 1_000_000_000_000,
      circulating: 400_000_000_000,
      staked: 250_000_000_000,
      burned: 50_000_000_000,
    },
    price: tokenState.price || {
      current: 0.00123,
      yesterday: 0.00118,
      high24h: 0.00135,
      low24h: 0.00115,
      marketCap: 492_000_000,
    },
    priceHistory: tokenState.priceHistory || Array.from({ length: 24 }, (_, i) => ({
      price: 0.001 + Math.random() * 0.0005 * Math.sin(i / 3),
    })),
    staking: tokenState.staking || {
      totalStaked: 250_000_000_000,
      stakingRatio: 25,
      apy: 12.5,
      tiers: [
        { name: 'Bronze', minStake: 10000, apy: 8, lockPeriod: '30 days', color: '#cd7f32' },
        { name: 'Silver', minStake: 100000, apy: 10, lockPeriod: '90 days', color: '#c0c0c0' },
        { name: 'Gold', minStake: 1000000, apy: 12, lockPeriod: '180 days', color: '#ffd700' },
        { name: 'Platinum', minStake: 10000000, apy: 15, lockPeriod: '365 days', color: '#e5e4e2' },
      ],
    },
    treasury: tokenState.treasury || {
      holdings: [
        { asset: 'FORMA', amount: 200_000_000_000, valueUsd: 246_000_000, icon: '💎' },
        { asset: 'ICP', amount: 5_000_000, valueUsd: 50_000_000, icon: '∞' },
        { asset: 'BTC', amount: 500, valueUsd: 30_000_000, icon: '₿' },
        { asset: 'ETH', amount: 10000, valueUsd: 25_000_000, icon: 'Ξ' },
        { asset: 'Stablecoins', amount: 20_000_000, valueUsd: 20_000_000, icon: '💵' },
      ],
    },
    burns: tokenState.burns || [
      { date: 'Cycle 145', amount: 10_000_000_000, reason: 'Quarterly burn' },
      { date: 'Cycle 130', amount: 15_000_000_000, reason: 'Quarterly burn' },
      { date: 'Cycle 115', amount: 12_000_000_000, reason: 'Quarterly burn' },
      { date: 'Cycle 100', amount: 8_000_000_000, reason: 'Inaugural burn' },
      { date: 'Cycle 50', amount: 5_000_000_000, reason: 'Jubilee burn' },
    ],
    pools: tokenState.pools || [
      { pair: 'FORMA/ICP', tvl: 45_000_000, volume24h: 2_500_000, apy: 45 },
      { pair: 'FORMA/ckBTC', tvl: 30_000_000, volume24h: 1_800_000, apy: 38 },
      { pair: 'FORMA/ckETH', tvl: 25_000_000, volume24h: 1_200_000, apy: 32 },
    ],
  };
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={{ fontSize: 20 }}>💎</span>
        <span style={styles.title}>FORMA Token Economics</span>
        <span style={{ fontSize: 9, color: '#68a', marginLeft: 'auto' }}>
          ${state.price.current.toFixed(6)} USD
        </span>
      </div>
      
      <div style={styles.content}>
        {/* Column 1: Supply & Distribution */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <TokenSupply supply={state.supply} />
          
          <div style={styles.distributionPanel}>
            <div style={{ fontSize: 10, color: '#6af', marginBottom: 8 }}>TOKEN DISTRIBUTION</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <DistributionPieChart distribution={DISTRIBUTION} />
              <div>
                {DISTRIBUTION.map(d => (
                  <div key={d.name} style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 6,
                    padding: '2px 0',
                    fontSize: 8,
                  }}>
                    <div style={{
                      width: 8,
                      height: 8,
                      borderRadius: 2,
                      background: d.color,
                    }} />
                    <span style={{ color: '#adf' }}>{d.name}</span>
                    <span style={{ color: d.color, marginLeft: 'auto' }}>{d.percentage}%</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
        
        {/* Column 2: Price & Staking */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <PriceOracle price={state.price} history={state.priceHistory} />
          <StakingPanel staking={state.staking} />
        </div>
        
        {/* Column 3: Treasury, Burns, Pools */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <Treasury treasury={state.treasury} />
          <BurnTracker burns={state.burns} />
          <LiquidityPools pools={state.pools} />
        </div>
      </div>
    </div>
  );
}
