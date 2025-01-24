import * as foobar from "./foobar";
import { expect } from "chai";

// @ts-ignore
global.it =
  typeof it === "function" ? it : (desc: string, fn: Function) => fn();

it("should work for numbers bigger than 1", () => {
  expect(foobar.test(2)).eql("bigger than 1");
});

it("should work for numbers smaller than 1", () => {
  expect(foobar.test(0)).eql("smaller than 1");
});
