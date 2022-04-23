import useMetaMask from "../../hooks/metamask";
import { abi } from "../../contracts/NFTini.json"
import { Token as contractAddress } from "../../contracts/contract-address.json"
// import {rinkeby_abi, rinkeby_abi as abi} from "../../testData"
// import { rinkeby_contract_address as contractAddress } from "../../testData"
import React from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import { Button } from 'react-bootstrap'
import Popup from "reactjs-popup";

const contentStyle = {
    maxWidth: '600px',
    width: '90%',
};

function CreateAlbum() {

    const { library, account } = useMetaMask()
    let contract;

    if (library) {
        contract = new library.eth.Contract(abi, contractAddress)
        contract.methods.albumId().call().then(function(result){

            console.log(result)
        });
    }

    const createAlbum = (collection) => {
        let tempCards = collection.cards.map((card) => {
            return { name: card.name, rarity: card.rarity }
        })
        contract.methods.createAlbum(collection.name, [...tempCards], collection.allowExpansion).send({ from: account}).then(console.log);
        console.log(collection.cards)
    }

    return <Popup trigger={<Button variant="secondary">Create Album</Button>} modal contentStyle={contentStyle} position="right center">
        {closeModal => (
        <div>
        <Formik
            initialValues={{cards: []}}
            onSubmit={
                values => {
                    createAlbum(values)
                    closeModal();
                }
            }
            render={({values}) => (
                <Form>
                    <h1>Create Album</h1>
                    <label htmlFor="name" style={{marginBottom: '10px'}}>Album Name: </label>
                    <Field name="name" style={{marginBottom: '10px'}}/>
                    <label htmlFor="allowExpansion" style={{marginBottom: '10px'}}>Allow Expansion: </label>
                    <Field name="allowExpansion" type="checkbox" />
                    <h2>Cards: </h2>
                    <FieldArray
                        name="cards"
                        render={arrayHelpers => (
                            <div>
                                {values.cards.map((card, index) => (
                                    <div key={index} style={{marginBottom: '30px'}}>
                                        {/** both these conventions do the same */}

                                        <Button style={{marginBottom: '10px'}} type="button" onClick={() => arrayHelpers.remove(index)}>
                                            -
                                        </Button>
                                        <div></div>
                                        <label htmlFor={`cards[${index}].name`} style={{marginBottom: '10px'}}>Card Name: </label>
                                        <Field name={`cards[${index}].name`} style={{marginBottom: '10px'}}/>
                                        <label htmlFor={`cards.${index}.rarity`} style={{marginBottom: '10px'}}>Card Rarity: </label>
                                        <Field name={`cards.${index}.rarity`} type="number" />
                                    </div>
                                ))}
                                <Button
                                    style={{marginBottom: '10px'}}
                                    type="button"
                                    onClick={() => arrayHelpers.push({ name: '', rarity: 0 })}
                                >
                                    +
                                </Button>
                            </div>

                        )}
                    />

                    <div>
                        <Button type="submit">Submit</Button>
                    </div>
                </Form>
            )}
        />
    </div>
        )}</Popup>

}

export default CreateAlbum