import React from 'react';

export default function GridLayer() {
  return (
    <div style={{
      position: 'absolute',
      inset: 0,
      backgroundImage:
        'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
      backgroundSize: '40px 40px',
      transform: 'perspective(600px) rotateX(60deg)',
      transformOrigin: 'top',
      opacity: 0.25
    }} />
  );
}
