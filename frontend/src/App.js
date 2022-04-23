import { useEffect } from 'react'
import './App.css'
import { Button } from 'react-bootstrap'
import useMetaMask from './hooks/metamask';
import Album from './components/album/Album'
import CreateAlbum from "./components/createalbum/CreateAlbum";
import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';


function App() {
  
  const { connect, disconnect, isActive, account, shouldDisable, library } = useMetaMask()
  const cards = [
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 1
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 2
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 3
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 4
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 5
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 6
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 7
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 8
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 9
    },
    {
      img_url: "https://i.pinimg.com/736x/a5/5a/31/a55a3167f0a068894620b8ef69fd9040.jpg",
      number: 10
    }
  ]
  console.log(library)

  return (
    <div className="App">
      <header className="App-header">
        {!isActive &&
          <Button variant="secondary" onClick={connect} disabled={shouldDisable}>
            <img src="images/metamask.svg" alt="MetaMask" width="50" height="50"/> Connect to MetaMask
          </Button>
        }
        {isActive &&
          <Button variant="danger" onClick={disconnect}>
            Disconnect MetaMask<img src="images/noun_waving_3666509.svg" width="50" height="50"/>
          </Button>
        }
        {isActive &&
            <CreateAlbum/>
        }
        <div className="mt-2 mb-2">
          Connected Account: { isActive ? account : '' }
        </div>
      </header>

      <Album all_cards={cards} user_cards={[1, 2, 3, 6, 7, 8, 10]}/>
    </div>
  );
}

export default App;
