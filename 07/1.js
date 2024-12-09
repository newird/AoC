function helper(i, n, acc, arr, target) {
	if (i == n) {
		if (acc == target) {
			return true;
		} else {
			return false;
		}
	}

	var res = false;
	const cur = arr[i];

	res |= helper(i + 1, n, acc + cur, arr, target);
	res |= helper(i + 1, n, acc * cur, arr, target);
	return res;
}
async function solve() {
	const decoder = new TextDecoder("utf-8");
	const input = await Deno.readFile("1.in");
	const lines = decoder
		.decode(input)
		.split("\n")
		.filter((line) => line.length > 0);
	var ans = 0;

	for (const line of lines) {
		const partition = line.split(":");
		const target = parseInt(partition[0]);
		const arr = partition[1]
			.trim()
			.split(" ")
			.map((element) => parseInt(element));
		const n = arr.length;
		if (helper(1, n, parseInt(arr[0]), arr, target)) {
			ans += target;
		}
	}
	console.log(ans);
}

await solve();
