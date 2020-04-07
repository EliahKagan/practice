#!/usr/bin/env node

// Some code to read integer data as text in Node, with a test.
// See also reader.in. To test, run:  ./reader.js <reader.in

'use strict';

function main(reader) {
    for (let i = 0; i < 5; ++i) {
        console.log(reader.read_record().map(n => n * n));
    }

    for (let i = 0; i < 3; ++i) {
        console.log(reader.read_value() / 2);
    }
}

(function () {
    const reads = [];
    process.stdin.resume();
    process.stdin.setEncoding('utf-8');
    process.stdin.on('data', data => reads.push(data));
    process.stdin.on('end', () => {
        const lines = reads.join('').split('\n');
        let index = 0;
        main(Object.freeze({
            read_value: function () {
                return parseInt(this._read_line());
            },
            read_record: function () {
                return this._read_line()
                           .split(/\s+/u)
                           .filter(tok => tok)
                           .map(tok => parseInt(tok));
            },
            _read_line: function () {
                return lines[index++];
            }
        }));
    });
})();
