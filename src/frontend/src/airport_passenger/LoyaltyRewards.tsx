// ═══════════════════════════════════════════════════════════════════════════════
// LOYALTY REWARDS — AEROPORTO Token Management
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════

import React from 'react';

interface LoyaltyRewardsProps {
  passengerId: string;
  tokenBalance: number;
}

interface Reward {
  title: string;
  cost: number;
  description: string;
  icon: string;
}

export function LoyaltyRewards({ passengerId, tokenBalance }: LoyaltyRewardsProps) {
  const rewards: Reward[] = [
    {
      title: 'Lounge Access',
      cost: 100,
      description: '2-hour access to premium airport lounge',
      icon: '🛋️'
    },
    {
      title: 'Priority Boarding',
      cost: 50,
      description: 'Board in Group 1 on your next flight',
      icon: '⚡'
    },
    {
      title: '$10 Dining Credit',
      cost: 200,
      description: 'Redeemable at any airport restaurant',
      icon: '🍽️'
    },
    {
      title: 'Fast Track Security',
      cost: 75,
      description: 'Skip the regular security line',
      icon: '🚀'
    },
    {
      title: 'Seat Upgrade',
      cost: 500,
      description: 'Upgrade to Economy Plus or Business Class',
      icon: '💺'
    },
    {
      title: 'Free Rebooking',
      cost: 1000,
      description: 'Waive $50 rebooking fee on flight changes',
      icon: '🔄'
    }
  ];

  const handleRedeem = (reward: Reward) => {
    if (tokenBalance >= reward.cost) {
      alert(`Redeemed: ${reward.title} for ${reward.cost} AEROPORTO tokens!`);
    } else {
      alert(`Not enough tokens. You need ${reward.cost - tokenBalance} more tokens.`);
    }
  };

  return (
    <div>
      <div style={{
        background: 'rgba(243, 156, 18, 0.1)',
        borderRadius: '12px',
        padding: '2rem',
        marginBottom: '2rem',
        border: '1px solid rgba(243, 156, 18, 0.3)',
        textAlign: 'center'
      }}>
        <h2 style={{ margin: 0, fontSize: '2.5rem' }}>
          {tokenBalance} ⬡
        </h2>
        <p style={{ margin: '0.5rem 0 0 0', color: '#95a5a6' }}>
          AEROPORTO Tokens Available
        </p>

        <div style={{
          marginTop: '1.5rem',
          display: 'flex',
          justifyContent: 'center',
          gap: '2rem',
          fontSize: '0.9rem'
        }}>
          <div>
            <div style={{ fontWeight: 'bold' }}>Tier: Gold</div>
            <div style={{ color: '#95a5a6' }}>φ² Multiplier</div>
          </div>
          <div>
            <div style={{ fontWeight: 'bold' }}>Lifetime Earned: 2,584</div>
            <div style={{ color: '#95a5a6' }}>Since January 2026</div>
          </div>
        </div>
      </div>

      <h3 style={{ marginBottom: '1.5rem' }}>Available Rewards</h3>

      <div style={{
        display: 'grid',
        gap: '1.5rem',
        gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))'
      }}>
        {rewards.map((reward, idx) => (
          <div
            key={idx}
            style={{
              background: 'rgba(255, 255, 255, 0.05)',
              borderRadius: '12px',
              padding: '1.5rem',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              display: 'flex',
              flexDirection: 'column',
              gap: '1rem'
            }}
          >
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start'
            }}>
              <div>
                <div style={{ fontSize: '2rem' }}>{reward.icon}</div>
                <h4 style={{ margin: '0.5rem 0', fontSize: '1.2rem' }}>
                  {reward.title}
                </h4>
              </div>
              <div style={{
                padding: '0.5rem 1rem',
                borderRadius: '6px',
                background: 'rgba(243, 156, 18, 0.2)',
                border: '1px solid rgba(243, 156, 18, 0.4)',
                fontWeight: 'bold'
              }}>
                {reward.cost} ⬡
              </div>
            </div>

            <p style={{ color: '#95a5a6', fontSize: '0.9rem', margin: 0 }}>
              {reward.description}
            </p>

            <button
              onClick={() => handleRedeem(reward)}
              disabled={tokenBalance < reward.cost}
              style={{
                padding: '0.75rem',
                borderRadius: '8px',
                border: 'none',
                background: tokenBalance >= reward.cost ?
                  'linear-gradient(135deg, #f39c12, #e74c3c)' :
                  'rgba(255, 255, 255, 0.1)',
                color: tokenBalance >= reward.cost ? 'white' : '#7f8c8d',
                fontWeight: 'bold',
                cursor: tokenBalance >= reward.cost ? 'pointer' : 'not-allowed',
                opacity: tokenBalance >= reward.cost ? 1 : 0.5
              }}
            >
              {tokenBalance >= reward.cost ? 'Redeem' : 'Not Enough Tokens'}
            </button>
          </div>
        ))}
      </div>

      <div style={{
        marginTop: '2rem',
        padding: '1.5rem',
        background: 'rgba(52, 152, 219, 0.1)',
        borderRadius: '12px',
        border: '1px solid rgba(52, 152, 219, 0.3)'
      }}>
        <h4 style={{ margin: '0 0 1rem 0' }}>Earn More Tokens</h4>
        <ul style={{ margin: 0, paddingLeft: '1.5rem', color: '#95a5a6' }}>
          <li>Complete flight surveys: 10 ⬡</li>
          <li>Check in at airport lounges: 25 ⬡</li>
          <li>Refer a friend: 50 ⬡</li>
          <li>Book last-minute flights: 75 ⬡</li>
          <li>Participate in social events: 100 ⬡</li>
        </ul>
      </div>
    </div>
  );
}
