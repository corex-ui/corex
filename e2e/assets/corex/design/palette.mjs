import { Theme, Color, BackgroundColor } from '@adobe/leonardo-contrast-colors';
import fs from 'fs';
import path from 'path';

// -----------------------------
// Flat theme configuration
// -----------------------------
const THEMES_CONFIG = {
  // NEO: Modern, clean blue-gray (refined & matte)
  'neo-light': {
    backgrounds: [
      {
        name: 'root',
        color: '#F5F7FA',
        lightness: 98,
        contrastColors: [
          { name: '-border', color: '#E1E4E8', ratio: 1.05 },
          { name: '-text', color: '#1A1D23', ratio: 7.5 },
          { name: '-muted', color: '#6B7280', ratio: 4.8 },
          { name: '-accent', color: '#4B5563', ratio: 7 },
          { name: '-brand', color: '#3B5BDB', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#FAFBFC',
        lightness: 96,
        contrastColors: [
          { name: '-border', color: '#E5E7EB', ratio: 1.05 },
          { name: '-text', color: '#1A1D23', ratio: 7.5 },
          { name: '-muted', color: '#6B7280', ratio: 4.8 },
          { name: '-accent', color: '#4B5563', ratio: 7 },
          { name: '-brand', color: '#3B5BDB', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#F3F4F6',
        lightness: 92,
        ratios: { default: -1.1, hover: -1.05, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D1D5DB', ratio: 1.08 },
          { name: '-text', color: '#1A1D23', ratio: 7.5 },
          { name: '-muted', color: '#6B7280', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#4B5563',
        lightness: 40,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6B7280', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#D1D5DB', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#3B5BDB',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#4B6BEB', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0E7FF', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#C94F4F',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D96666', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#FEE2E2', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-info',
        color: '#5B8AB8',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6B9AC8', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0F2FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-success',
        color: '#4FA37C',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#5FB38C', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#D1FAE5', ratio: 4.8 }
        ]
      }
    ],
    output: 'tokens/multi/themes/neo/light.json',
    indent: 2
  },

  'neo-dark': {
    backgrounds: [
      {
        name: 'root',
        color: '#1A1D23',
        lightness: 8,
        contrastColors: [
          { name: '-border', color: '#2D3139', ratio: 1.4 },
          { name: '-text', color: '#E5E7EB', ratio: 9 },
          { name: '-muted', color: '#9CA3AF', ratio: 6 },
          { name: '-accent', color: '#D1D5DB', ratio: 7 },
          { name: '-brand', color: '#5472E4', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#1F2329',
        lightness: 10,
        contrastColors: [
          { name: '-border', color: '#33373F', ratio: 1.4 },
          { name: '-text', color: '#E5E7EB', ratio: 9 },
          { name: '-muted', color: '#9CA3AF', ratio: 6 },
          { name: '-accent', color: '#D1D5DB', ratio: 7 },
          { name: '-brand', color: '#5472E4', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#252930',
        lightness: 14,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#3D424A', ratio: 1.4 },
          { name: '-text', color: '#E5E7EB', ratio: 9 },
          { name: '-muted', color: '#9CA3AF', ratio: 6 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#D1D5DB',
        lightness: 70,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#E5E7EB', ratio: 1.1 },
          { name: '-text', color: '#111827', ratio: 9 },
          { name: '-muted', color: '#374151', ratio: 6 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#5472E4',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6482F4', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#1E3A8A', ratio: 6 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#E06666',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#F07676', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#7F1D1D', ratio: 6 }
        ]
      },
      {
        name: 'ui-info',
        color: '#7BA3D1',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#8BB3E1', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#1E3A8A', ratio: 6 }
        ]
      },
      {
        name: 'ui-success',
        color: '#6BB896',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7BC8A6', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#064E3B', ratio: 6 }
        ]
      }
    ],
    output: 'tokens/multi/themes/neo/dark.json',
    indent: 2
  },

  'uno-light': {
    backgrounds: [
      {
        name: 'root',
        color: '#F8F7FA',
        lightness: 96,
        contrastColors: [
          { name: '-border', color: '#E4E2E8', ratio: 1.08 },
          { name: '-text', color: '#2A2838', ratio: 9 },
          { name: '-muted', color: '#64748B', ratio: 6 },
          { name: '-accent', color: '#7C6B8F', ratio: 7 },
          { name: '-brand', color: '#6B5B8D', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#FAFBFC',
        lightness: 92,
        contrastColors: [
          { name: '-border', color: '#E4E2E8', ratio: 1.08 },
          { name: '-text', color: '#2A2838', ratio: 9 },
          { name: '-muted', color: '#64748B', ratio: 6 },
          { name: '-accent', color: '#7C6B8F', ratio: 7 },
          { name: '-brand', color: '#6B5B8D', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#F2F1F5',
        lightness: 88,
        ratios: { default: -1.1, hover: -1.05, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D8D5DD', ratio: 1.1 },
          { name: '-text', color: '#2A2838', ratio: 7.5 },
          { name: '-muted', color: '#64748B', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#7C6B8F',
        lightness: 78,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#8C7B9F', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E8E6EC', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#6B5B8D',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7B6B9D', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#EDE9FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#C94F4F',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D96666', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#FEE2E2', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-info',
        color: '#5B8AB8',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6B9AC8', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0F2FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-success',
        color: '#4FA37C',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#5FB38C', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#D1FAE5', ratio: 4.8 }
        ]
      }
    ],
    output: 'tokens/multi/themes/uno/light.json',
    indent: 2
  },

  'uno-dark': {
    backgrounds: [
      {
        name: 'root',
        color: '#1D1A24',
        lightness: 7,
        contrastColors: [
          { name: '-border', color: '#2E2A38', ratio: 1.4 },
          { name: '-text', color: '#E5E2EB', ratio: 9 },
          { name: '-muted', color: '#9B95A8', ratio: 6 },
          { name: '-accent', color: '#B8AEC8', ratio: 7 },
          { name: '-brand', color: '#8B7BA8', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#23202E',
        lightness: 10,
        contrastColors: [
          { name: '-border', color: '#34303E', ratio: 1.4 },
          { name: '-text', color: '#E5E2EB', ratio: 9 },
          { name: '-muted', color: '#9B95A8', ratio: 6 },
          { name: '-accent', color: '#B8AEC8', ratio: 7 },
          { name: '-brand', color: '#8B7BA8', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#2A2636',
        lightness: 13,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#3D3848', ratio: 1.4 },
          { name: '-text', color: '#E5E2EB', ratio: 9 },
          { name: '-muted', color: '#9B95A8', ratio: 6 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#B8AEC8',
        lightness: 65,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#C8BED8', ratio: 1.1 },
          { name: '-text', color: '#1D1A24', ratio: 9 },
          { name: '-muted', color: '#3D3848', ratio: 6 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#8B7BA8',
        lightness: 60,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#9B8BB8', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#2A2636', ratio: 6 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#E06666',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#F07676', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#7F1D1D', ratio: 6 }
        ]
      },
      {
        name: 'ui-info',
        color: '#7BA3D1',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#8BB3E1', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#1E3A8A', ratio: 6 }
        ]
      },
      {
        name: 'ui-success',
        color: '#6BB896',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7BC8A6', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#064E3B', ratio: 6 }
        ]
      }
    ],
    output: 'tokens/multi/themes/uno/dark.json',
    indent: 2
  },

  // DUO: Soft warm taupe & muted terracotta
  'duo-light': {
    backgrounds: [
      {
        name: 'root',
        color: '#F9F7F4',
        lightness: 97,
        contrastColors: [
          { name: '-border', color: '#E6E2DC', ratio: 1.05 },
          { name: '-text', color: '#2E2822', ratio: 7.5 },
          { name: '-muted', color: '#72685D', ratio: 4.8 },
          { name: '-accent', color: '#8B7A6A', ratio: 7 },
          { name: '-brand', color: '#9D6C55', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#FDFCFB',
        lightness: 99,
        contrastColors: [
          { name: '-border', color: '#EAE6E0', ratio: 1.05 },
          { name: '-text', color: '#2E2822', ratio: 7.5 },
          { name: '-muted', color: '#72685D', ratio: 4.8 },
          { name: '-accent', color: '#8B7A6A', ratio: 7 },
          { name: '-brand', color: '#9D6C55', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#F4F1ED',
        lightness: 95,
        ratios: { default: -1.1, hover: -1.05, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D9D3CA', ratio: 1.08 },
          { name: '-text', color: '#2E2822', ratio: 7.5 },
          { name: '-muted', color: '#72685D', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#8B7A6A',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#9B8A7A', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#EAE6E0', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#9D6C55',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#AD7C65', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#FFF5ED', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#C94F4F',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D96666', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#FEE2E2', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-info',
        color: '#5B8AB8',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6B9AC8', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0F2FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-success',
        color: '#4FA37C',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#5FB38C', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#D1FAE5', ratio: 4.8 }
        ]
      }
    ],
    output: 'tokens/multi/themes/duo/light.json',
    indent: 2
  },

  'duo-dark': {
    backgrounds: [
      {
        name: 'root',
        color: '#221E1A',
        lightness: 7,
        contrastColors: [
          { name: '-border', color: '#32291E', ratio: 1.4 },
          { name: '-text', color: '#EAE6E0', ratio: 9 },
          { name: '-muted', color: '#9D9189', ratio: 6 },
          { name: '-accent', color: '#B8A697', ratio: 7 },
          { name: '-brand', color: '#B88C73', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#2A241E',
        lightness: 10,
        contrastColors: [
          { name: '-border', color: '#3A2F24', ratio: 1.4 },
          { name: '-text', color: '#EAE6E0', ratio: 9 },
          { name: '-muted', color: '#9D9189', ratio: 6 },
          { name: '-accent', color: '#B8A697', ratio: 7 },
          { name: '-brand', color: '#B88C73', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#312A23',
        lightness: 13,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#433A2F', ratio: 1.4 },
          { name: '-text', color: '#EAE6E0', ratio: 9 },
          { name: '-muted', color: '#9D9189', ratio: 6 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#B8A697',
        lightness: 65,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#C8B6A7', ratio: 1.1 },
          { name: '-text', color: '#221E1A', ratio: 9 },
          { name: '-muted', color: '#3A2F24', ratio: 6 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#B88C73',
        lightness: 60,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#C89C83', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#3A2F24', ratio: 6 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#E06666',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#F07676', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#7F1D1D', ratio: 6 }
        ]
      },
      {
        name: 'ui-info',
        color: '#7BA3D1',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#8BB3E1', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#1E3A8A', ratio: 6 }
        ]
      },
      {
        name: 'ui-success',
        color: '#6BB896',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7BC8A6', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#064E3B', ratio: 6 }
        ]
      }
    ],
    output: 'tokens/multi/themes/duo/dark.json',
    indent: 2
  },

  // LEO: Cool slate & muted teal
  'leo-light': {
    backgrounds: [
      {
        name: 'root',
        color: '#F6F8F9',
        lightness: 97,
        contrastColors: [
          { name: '-border', color: '#E3E7E9', ratio: 1.05 },
          { name: '-text', color: '#1E2528', ratio: 7.5 },
          { name: '-muted', color: '#5F6D73', ratio: 4.8 },
          { name: '-accent', color: '#5A707A', ratio: 7 },
          { name: '-brand', color: '#4A7C8C', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#FBFCFD',
        lightness: 99,
        contrastColors: [
          { name: '-border', color: '#E7EBED', ratio: 1.05 },
          { name: '-text', color: '#1E2528', ratio: 7.5 },
          { name: '-muted', color: '#5F6D73', ratio: 4.8 },
          { name: '-accent', color: '#5A707A', ratio: 7 },
          { name: '-brand', color: '#4A7C8C', ratio: 7 },
          { name: '-alert', color: '#C94F4F', ratio: 7 },
          { name: '-info', color: '#5B8AB8', ratio: 7 },
          { name: '-success', color: '#4FA37C', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#F1F4F5',
        lightness: 95,
        ratios: { default: -1.1, hover: -1.05, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D6DCDF', ratio: 1.08 },
          { name: '-text', color: '#1E2528', ratio: 7.5 },
          { name: '-muted', color: '#5F6D73', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#5A707A',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6A808A', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E7EBED', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#4A7C8C',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#5A8C9C', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0F2FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#C94F4F',
        lightness: 45,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#D96666', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#FEE2E2', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-info',
        color: '#5B8AB8',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#6B9AC8', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#E0F2FE', ratio: 4.8 }
        ]
      },
      {
        name: 'ui-success',
        color: '#4FA37C',
        lightness: 48,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#5FB38C', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 7.5 },
          { name: '-muted', color: '#D1FAE5', ratio: 4.8 }
        ]
      }
    ],
    output: 'tokens/multi/themes/leo/light.json',
    indent: 2
  },

  'leo-dark': {
    backgrounds: [
      {
        name: 'root',
        color: '#1A1F22',
        lightness: 7,
        contrastColors: [
          { name: '-border', color: '#2D3438', ratio: 1.4 },
          { name: '-text', color: '#E3E7E9', ratio: 9 },
          { name: '-muted', color: '#93A1A8', ratio: 6 },
          { name: '-accent', color: '#A8B8C0', ratio: 7 },
          { name: '-brand', color: '#6A9CAC', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'layer',
        color: '#20252A',
        lightness: 10,
        contrastColors: [
          { name: '-border', color: '#353D42', ratio: 1.4 },
          { name: '-text', color: '#E3E7E9', ratio: 9 },
          { name: '-muted', color: '#93A1A8', ratio: 6 },
          { name: '-accent', color: '#A8B8C0', ratio: 7 },
          { name: '-brand', color: '#6A9CAC', ratio: 7 },
          { name: '-alert', color: '#E06666', ratio: 7 },
          { name: '-info', color: '#7BA3D1', ratio: 7 },
          { name: '-success', color: '#6BB896', ratio: 7 }
        ]
      },
      {
        name: 'ui',
        color: '#272D32',
        lightness: 13,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#3F474D', ratio: 1.4 },
          { name: '-text', color: '#E3E7E9', ratio: 9 },
          { name: '-muted', color: '#93A1A8', ratio: 6 }
        ]
      },
      {
        name: 'ui-accent',
        color: '#A8B8C0',
        lightness: 65,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#B8C8D0', ratio: 1.1 },
          { name: '-text', color: '#1A1F22', ratio: 9 },
          { name: '-muted', color: '#353D42', ratio: 6 }
        ]
      },
      {
        name: 'ui-brand',
        color: '#6A9CAC',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7AACBC', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#164E63', ratio: 6 }
        ]
      },
      {
        name: 'ui-alert',
        color: '#E06666',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#F07676', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#7F1D1D', ratio: 6 }
        ]
      },
      {
        name: 'ui-info',
        color: '#7BA3D1',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#8BB3E1', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#1E3A8A', ratio: 6 }
        ]
      },
      {
        name: 'ui-success',
        color: '#6BB896',
        lightness: 58,
        ratios: { default: -1.15, hover: -1.08, active: 1 },
        contrastColors: [
          { name: '-border', color: '#7BC8A6', ratio: 1.1 },
          { name: '-text', color: '#FFFFFF', ratio: 9 },
          { name: '-muted', color: '#064E3B', ratio: 6 }
        ]
      }
    ],
    output: 'tokens/multi/themes/leo/dark.json',
    indent: 2
  }
};
// -----------------------------
function ensureDirExists(filePath) {
  const dir = path.dirname(filePath);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
}

// -----------------------------
function createBackground(bg) {
  const ratios = bg.ratios || { default: 1 };
  const colorKeys = Array.isArray(bg.color) ? bg.color : [bg.color].filter(Boolean);
  return new BackgroundColor({ name: bg.name, colorKeys: colorKeys.length ? colorKeys : ['#ffffff'], ratios });
}

// -----------------------------
function createTextColors(textColorConfigs) {
  return (textColorConfigs || []).map(tc => {
    const colorKeys = Array.isArray(tc.color) ? tc.color : [tc.color].filter(Boolean);
    const ratio = typeof tc.ratio === 'number' ? tc.ratio : 1;
    return new Color({ name: tc.name, colorKeys: colorKeys.length ? colorKeys : ['#000000'], ratios: { default: ratio } });
  });
}

// -----------------------------
function generateThemes(themeConfig) {
  if (!themeConfig || !themeConfig.backgrounds) return [];
  return themeConfig.backgrounds.map(bgConfig => {
    const background = createBackground(bgConfig);
    const contrastColors = createTextColors(bgConfig.contrastColors);
    return new Theme({
      colors: [background, ...contrastColors],
      backgroundColor: background,
      lightness: bgConfig.lightness
    });
  });
}

// -----------------------------
// Convert Leonardo output to Style Dictionary JSON with theme structure
// -----------------------------
function toStyleDictionaryFormat(themes, themeName) {
  const result = {};
  const themeKey = themeName || "theme";

  result[themeKey] = {
    color: {}
  };

  themes.forEach(theme => {
    const bg = theme._backgroundColor;
    const mainState = Object.entries(bg._ratios || {}).find(([, ratio]) => ratio === 1)?.[0] || 'default';

    // Find the contrast color object that matches the background name
    const backgroundColorObj = theme._contrastColors?.find(colorObj => colorObj.name === bg._name);

    // If no values, just fallback to background color
    const bgValue = backgroundColorObj?.values?.find(v => v.name === mainState)?.value
      || bg._colorKeys?.[0];

    // Initialize background name
    if (!result[themeKey].color[bg._name]) {
      result[themeKey].color[bg._name] = {};
    }

    // Add contrast colors (text, muted, etc.)
    theme._contrastColors?.forEach(colorObj => {
      if (!colorObj.name || colorObj.name === bg._name) return;

      const key = colorObj.name;
      if (!result[themeKey].color[bg._name][key]) {
        result[themeKey].color[bg._name][key] = {};
      }

      // If values exist, use them; otherwise, use default ratio/color
      if (colorObj.values?.length) {
        colorObj.values.forEach(v => {
          const stateName = v.name || 'default';
          result[themeKey].color[bg._name][key][stateName] = {
            value: v.value,
            type: 'color',
            description: `${v.contrast}:1 contrast against ${bg._name}-${mainState} (${bgValue})`
          };
        });
      } else {
        // fallback single value
        const stateName = 'default';
        const value = colorObj._colorKeys?.[0] || bg._colorKeys?.[0];
        const contrast = colorObj.ratios?.default ?? 1;
        result[themeKey].color[bg._name][key][stateName] = {
          value,
          type: 'color',
          description: `${contrast}:1 contrast against ${bg._name}-${mainState} (${bgValue})`
        };
      }
    });

    // Add background colors (default, hover, active states)
    if (backgroundColorObj?.values?.length) {
      backgroundColorObj.values.forEach(v => {
        const stateName = v.name || 'default';
        result[themeKey].color[bg._name][stateName] = {
          value: v.value,
          type: 'color',
          description: `${v.contrast}:1 contrast against ${bg._name}-${mainState} (${bgValue})`
        };
      });
    } else {
      // fallback to base background color
      const stateName = 'default';
      result[themeKey].color[bg._name][stateName] = {
        value: bg._colorKeys?.[0],
        type: 'color',
        description: `Base background ${bg._name}-${mainState}`
      };
    }
  });

  return result;
}


// -----------------------------
function toStyleDictionarySemanticFormat(themes) {
  const result = { color: {} };

  themes.forEach(theme => {
    const bg = theme._backgroundColor;
    const bgName = bg._name; // just "root", "layer", "ui"
    if (!result.color[bgName]) result.color[bgName] = {};

    // background states
    if (bg._ratios && Object.keys(bg._ratios).length) {
      Object.keys(bg._ratios).forEach(stateName => {
        result.color[bgName][stateName] = {
          value: `{theme.color.${bgName}.${stateName}}`,
          type: 'color'
        };
      });
    } else if (bg._colorKeys?.length) {
      result.color[bgName].default = {
        value: `{theme.color.${bgName}.default}`,
        type: 'color'
      };
    }

    // contrast colors
    theme._contrastColors?.forEach(colorObj => {
      if (!colorObj.name || colorObj.name === bgName) return;
      const key = colorObj.name.startsWith('-') ? colorObj.name : `-${colorObj.name}`;
      if (!result.color[bgName][key]) result.color[bgName][key] = {};

      colorObj.values?.forEach(v => {
        const stateName = v.name || 'default';
        result.color[bgName][key][stateName] = {
          value: `{theme.color.${bgName}.${key}.${stateName}}`,
          type: 'color'
        };
      });
    });
  });

  return result;
}



// -----------------------------
function generateAllThemes(config = THEMES_CONFIG) {
  Object.entries(config).forEach(([themeKey, themeConfig]) => {
    console.log(`🎨 Generating theme ${themeKey}...`);
    const themes = generateThemes(themeConfig);
    const sd = toStyleDictionaryFormat(themes);
    ensureDirExists(themeConfig.output);
    fs.writeFileSync(themeConfig.output, JSON.stringify(sd, null, themeConfig.indent) + '\n');
    console.log(`✅ ${themeConfig.output} created!`);
  });

  // semantic tokens
  const semanticResult = { color: {} };
  Object.entries(config).forEach(([, themeConfig]) => {
    const themes = generateThemes(themeConfig);
    const semantic = toStyleDictionarySemanticFormat(themes);

    // merge
    Object.entries(semantic.color).forEach(([bgName, bgVals]) => {
      if (!semanticResult.color[bgName]) semanticResult.color[bgName] = {};
      semanticResult.color[bgName] = {
        ...semanticResult.color[bgName],
        ...bgVals
      };
    });
  });

  const semanticFilename = 'tokens/multi/semantic/color.json';
  ensureDirExists(semanticFilename);
  fs.writeFileSync(semanticFilename, JSON.stringify(semanticResult, null, 2) + '\n');
  console.log(`✅ ${semanticFilename} created!`);
  console.log(`\n🎉 All themes and semantic tokens generated successfully!`);
}

generateAllThemes();

export { generateAllThemes, THEMES_CONFIG };