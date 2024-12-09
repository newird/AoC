use regex::Regex;
use std::{fs::read_to_string, path::Path};

fn main() {
    let file = Path::new("../2.in");
    let pattern = r"(mul\((\d{1,3}),(\d{1,3})\))|(do\(\))|(don't\(\))";

    let re = Regex::new(pattern).unwrap();

    let mut total = 0;
    let mut enabled = true;

    for s in read_to_string(file).unwrap().lines() {
        for caps in re.captures_iter(&s) {
            if caps.get(1).is_some() {
                if enabled {
                    let x: i32 = caps.get(2).unwrap().as_str().parse().unwrap();
                    let y: i32 = caps.get(3).unwrap().as_str().parse().unwrap();
                    total += x * y;
                }
            } else if caps.get(4).is_some() {
                enabled = true;
            } else if caps.get(5).is_some() {
                enabled = false;
            }
        }
    }

    println!("{}", total);
}
