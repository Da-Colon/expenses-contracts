const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config({ path: './.env.local' })

module.exports = {
  networks: {
    contracts_build_directory: 'built-contracts',
    networks: {
      robsten: {
        provider: () => new HDWalletProvider({
          privateKeys: [process.env.ROBSTEN_PRIVATE_KEY],
          providerOrUrl: process.env.ROBSTEN_PROVIDER,
        }),
        network_id: '3',
      },
      rinkeby: {
        provider: () => new HDWalletProvider({
          privateKeys: [process.env.RINKEBY_PRIVATE_KEY],
          providerOrUrl: process.env.RINKEBY_PROVIDER,
        }),
        network_id: '4',
      },
      goerli: {
        provider: () => new HDWalletProvider({
          privateKeys: [process.env.GOERLI_PRIVATE_KEY],
          providerOrUrl: process.env.GOERLI_PROVIDER,
        }),
        network_id: '5',
      }
    }
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.0", 
      settings: {
        optimizer: {
          enabled: true,
          runs: 1000
        }
      }
    }
  },

  // Truffle DB is currently disabled by default; to enable it, change enabled: false to enabled: true
  //
  // Note: if you migrated your contracts prior to enabling this field in your Truffle project and want
  // those previously migrated contracts available in the .db directory, you will need to run the following:
  // $ truffle migrate --reset --compile-all

  db: {
    enabled: false
  }
};
