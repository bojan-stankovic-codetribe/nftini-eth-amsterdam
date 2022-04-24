import { useState } from 'react'
import { create } from 'ipfs-http-client'
import { useField } from 'formik';

const client = create('https://ipfs.infura.io:5001/api/v0')

const UploadFile = ({ ...props }) => {
    const [field, meta, helpers] = useField(props);
    const [fileUrl, updateFileUrl] = useState(``)

    async function onChange(e) {
        const file = e.target.files[0]
        try {
            const added = await client.add(file)
            const url = `https://ipfs.infura.io/ipfs/${added.path}`
            updateFileUrl(url)
            helpers.setValue(url)
        } catch (error) {
            console.log('Error uploading file: ', error)
        }
    }
    return (
        <div className="App">
            <input {...field} {...props} disabled="disabled" />
            <input
                type="file"
                onChange={onChange}
            />
            {
                fileUrl && (
                    <img src={fileUrl} width="600px" />
                )
            }
        </div>
    );
}

export default UploadFile