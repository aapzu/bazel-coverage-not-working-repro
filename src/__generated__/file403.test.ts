
import { getFile403Message } from "./file403";
import { expect } from "chai";

describe("file403 Tests", () => {
    it("should return the correct message", () => {
        const message = getFile403Message();
        expect(message).to.equal("Hello from file403!");
    });
});
