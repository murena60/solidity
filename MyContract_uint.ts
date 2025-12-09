import { expect } from "chai";
import { ethers } from "hardhat";

describe("MyContract", function () {
    let myContract: any;

    beforeEach(async function () {
        const MyContract = await ethers.getContractFactory("MyContract");
        myContract = await MyContract.deploy();
        await myContract.deployed();
    });

    it("should set and get data correctly", async function () {
        await myContract.setData(42);
        const data = await myContract.getData();
        expect(data).to.equal(42);
    });

    it("should process array correctly", async function () {
        const arr = [1, 2, 3];
        const result = await myContract.processArray(arr);
        const expectedSum = 1*1 + 2*2 + 3*3; // 1 + 4 + 9 = 14
        expect(result).to.equal(expectedSum);
    });

    it("should return 0 for an empty array", async function () {
        const arr: number[] = [];
        const result = await myContract.processArray(arr);
        expect(result).to.equal(0);
    });
});
