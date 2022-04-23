import { ReactComponent as NotOwned } from "../../assets/not_owned.svg"

function Album({all_cards, user_cards}) {
    return (
        <div className="card-collection">
            <div className="layout">
                {all_cards && all_cards.map((card) => (
                    <div className="card-item">
                        {user_cards.includes(card.number) &&
                            <img
                                src={card.img_url}
                                alt="Avatar"
                                className="image"
                            />
                        }
                        {!user_cards.includes(card.number) &&
                            <NotOwned
                                src={card.img_url}
                                alt="Avatar"
                                className="card-item-img"
                            />
                        }
                            <div className="overlay">{card.number}</div>
                    </div>
                ))}
            </div>
        </div>
    )
}

export default Album