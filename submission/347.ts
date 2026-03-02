// LeetCode No.347 Top K Frequent Elements

function topKFrequent(nums: number[], k: number): number[] {
    let occurences = new Map<number, number>();

    for (const num of nums) {
        if (occurences.get(num)) {
            const newValue = occurences.get(num);
            occurences.set(num, newValue + 1);
        } else {
            occurences.set(num, 1);
        }
    }

    let result = Array.from(occurences);
    result = result.sort((a, b): number => { return b[1] - a[1] });
    const mapped = result.map((a): number => { return a[0] })

    return mapped.slice(0, k);
};
