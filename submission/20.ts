// LeetCode No.20 Valid Parentheses

function isValid(s: string): boolean {
    let stack = new Array();

    for (const parenthese of s) {
        if (parenthese === ")") {
            if (stack[stack.length - 1] == "(") {
                stack.pop();
            } else {
                stack.push(parenthese);
            }
        } else if (parenthese === "}") {
            if (stack[stack.length - 1] == "{") {
                stack.pop();
            } else {
                stack.push(parenthese);
            }
        } else if (parenthese === "]") {
            if (stack[stack.length - 1] == "[") {
                stack.pop();
            } else {
                stack.push(parenthese);
            }
        } else {
            stack.push(parenthese);
        }
    }

    return stack.length === 0;
};