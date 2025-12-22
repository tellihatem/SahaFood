/*
  Warnings:

  - Added the required column `discount_applied` to the `OrderVoucher` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "OrderVoucher" ADD COLUMN     "discount_applied" DOUBLE PRECISION NOT NULL;
