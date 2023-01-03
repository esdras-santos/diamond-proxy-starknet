const fs = require('fs');

async function hardcodeAddress(hexStringReplacement) {
    const filePath = '../contracts/libraries/LibDiamond.sol';
    hexStringReplacement = hexStringReplacement.replace(/^0x/, '');

    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) throw err;

        const hexStrings = data.match(/0x[a-fA-F0-9]{40}/g);

        let modifiedData = data;
        for (const hexString of hexStrings) {
        modifiedData = modifiedData.replace(hexString, hexStringReplacement);
        }

        fs.writeFile(filePath, modifiedData, 'utf8', (writeErr) => {
        if (writeErr) throw writeErr;
        console.log('Done!');
        });
    });
}

exports.hardcodeAddress = hardcodeAddress
