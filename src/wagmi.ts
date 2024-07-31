import { coinbaseWallet, injected, walletConnect } from '@wagmi/connectors'
import { http, createConfig } from '@wagmi/core'
import { mainnet, sepolia, arbitrum } from '@wagmi/core/chains'

export const config = createConfig({
  chains: [mainnet, arbitrum],
  connectors: [],
  transports: {
    [mainnet.id]: http(),
    [arbitrum.id]: http(),
  },
})
