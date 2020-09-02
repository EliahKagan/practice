#!/usr/bin/env node

// HackerRank - Simple Text Editor
// https://www.hackerrank.com/challenges/simple-text-editor
// naive approach, storing full snapshots

'use strict';

class Editor {
    constructor() {
        this._buffers = [''];
    }

    append(text) {
        this._buffers.push(this._current() + text);
    }

    truncate_by(count) {
        this._buffers.push(this._current().slice(0, -count));
    }

    print(index) {
        console.log(this._current()[index - 1]);
    }

    undo() {
        --this._buffers.length;
    }

    _current() {
        return this._buffers[this._buffers.length - 1];
    }
}

function main(getln) {
    const editor = new Editor();

    for (let q = parseInt(getln()); q > 0; --q) {
        const tokens = getln().split(/\s+/u).filter(tok => tok);

        switch (parseInt(tokens[0])) {
        case 1:
            editor.append(tokens[1]);
            break;

        case 2:
            editor.truncate_by(parseInt(tokens[1]));
            break;

        case 3:
            editor.print(parseInt(tokens[1]));
            break;

        case 4:
            editor.undo();
            break;
        }
    }
}

function run() {
    const reads = [];
    process.stdin.resume();
    process.stdin.setEncoding('utf-8');
    process.stdin.on('data', data => reads.push(data));
    process.stdin.on('end', () => {
        const lines = reads.join('').split('\n');
        let index = 0;
        main(() => lines[index++]);
    });
}

if (require.main === module) {
    run();
}
