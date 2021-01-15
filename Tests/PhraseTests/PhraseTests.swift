//
//  PhraseTests.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © 2020 Philip Niedertscheider. All rights reserved.
//

import Quick
import Nimble
@testable import Phrase

class PhraseTests: QuickSpec {

    override func spec() {
        describe("Phrase") {

            it("should fails with empty expression") {
                expect {
                    try Phrase("")
                }.to(throwError(PhraseError.expressionIsEmpty))
            }

            describe("boolean constants") {

                it("should evaluate truth constant") {
                    expect {
                        let expression = try Phrase("true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate false constant") {
                    expect {
                        let expression = try Phrase("false")
                        return try expression.evaluate()
                    } == false
                }
            }

            describe("not") {

                it("should invert truthy constant") {
                    expect {
                        let expression = try Phrase("!true")
                        return try expression.evaluate()
                    } == false
                }

                it("should invert falsey constant") {
                    expect {
                        let expression = try Phrase("!false")
                        return try expression.evaluate()
                    } == true
                }
            }

            describe("and") {

                it("should evaluate truthy and truthy to be true") {
                    expect {
                        let expression = try Phrase("true && true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate truthy and falsey to be false") {
                    expect {
                        let expression = try Phrase("true && false")
                        return try expression.evaluate()
                    } == false
                }

                it("should evaluate falsey and truthy to be false") {
                    expect {
                        let expression = try Phrase("false && true")
                        return try expression.evaluate()
                    } == false
                }

                it("should evaluate falsey and falsey to be false") {
                    expect {
                        let expression = try Phrase("false && false")
                        return try expression.evaluate()
                    } == false
                }
            }

            describe("or") {

                it("should evaluate truthy or truthy to be true") {
                    expect {
                        let expression = try Phrase("true || true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate truthy or falsey to be true") {
                    expect {
                        let expression = try Phrase("true || false")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate falsey or truthy to be true") {
                    expect {
                        let expression = try Phrase("false || true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate falsey or falsey to be false") {
                    expect {
                        let expression = try Phrase("false || false")
                        return try expression.evaluate()
                    } == false
                }
            }

            describe("concatenated boolean") {

                it("should evaluate multiple and operators") {
                    expect {
                        let expression = try Phrase("true && true && true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate multiple and operators") {
                    expect {
                        let expression = try Phrase("true && true && false")
                        return try expression.evaluate()
                    } == false
                }

                it("should evaluate multiple and operators") {
                    expect {
                        let expression = try Phrase("true || true || true")
                        return try expression.evaluate()
                    } == true
                }

                it("should evaluate multiple and operators") {
                    expect {
                        let expression = try Phrase("false || false || false")
                        return try expression.evaluate()
                    } == false
                }

                it("should evaluate first boolean operator with higher priority") {
                    expect {
                        let expression = try Phrase("false || true && true")
                        return try expression.evaluate()
                    } == true
                }
            }

            describe("equatable") {

                describe("equality") {

                    it("should fail to compare constants of different types equality") {
                        expect {
                            let expression = try Phrase("1 == 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should equate the same constant to be true") {
                        expect {
                            let expression = try Phrase("1 == 1")
                            return try expression.evaluate()
                        } == true
                    }

                    it("should equate different constants to be false") {
                        expect {
                            let expression = try Phrase("1 == 0")
                            return try expression.evaluate()
                        } == false
                    }

                    describe("nullability") {

                        it("should return true if variable is not given") {
                            expect {
                                let expression = try Phrase("a == nil")
                                return try expression.evaluate()
                            } == true
                        }

                        it("should return false if variable is given") {
                            expect {
                                let expression = try Phrase("a == nil")
                                expression.context = [
                                    "a": 1
                                ]
                                return try expression.evaluate()
                            } == false
                        }
                    }
                }

                describe("inequality") {

                    it("should fail to compare constants of different types for inequality") {
                        expect {
                            let expression = try Phrase("1 != 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should equate the same constant to be true") {
                        expect {
                            let expression = try Phrase("1 != 1")
                            return try expression.evaluate()
                        } == false
                    }

                    it("should equate different constants to be false") {
                        expect {
                            let expression = try Phrase("1 != 0")
                            return try expression.evaluate()
                        } == true
                    }

                    describe("nullability") {

                        it("should return true if variable is given") {
                            expect {
                                let expression = try Phrase("a != nil")
                                expression.context = [
                                    "a": 1
                                ]
                                return try expression.evaluate()
                            } == true
                        }

                        it("should return false if variable is not given") {
                            expect {
                                let expression = try Phrase("a != nil")
                                return try expression.evaluate()
                            } == false
                        }
                    }
                }
            }

            describe("comparison") {

                describe("greater than") {

                    it("should fail to compare constants of different types") {
                        expect {
                            let expression = try Phrase("1 > 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should compare greater value to be truthy") {
                        expect {
                            let expression = try Phrase("2 > 1")
                            return try expression.evaluate()
                        } == true
                    }

                    it("should compare equal value to be false") {
                        expect {
                            let expression = try Phrase("2 > 2")
                            return try expression.evaluate()
                        } == false
                    }

                    it("should compare smaller value to be false") {
                        expect {
                            let expression = try Phrase("2 > 3")
                            return try expression.evaluate()
                        } == false
                    }
                }

                describe("greater than or equal") {

                    it("should fail to compare constants of different types") {
                        expect {
                            let expression = try Phrase("1 >= 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should compare greater value to be truthy") {
                        expect {
                            let expression = try Phrase("2 >= 1")
                            return try expression.evaluate()
                        } == true
                    }

                    it("should compare equal value to be truthy") {
                        expect {
                            let expression = try Phrase("2 >= 2")
                            return try expression.evaluate()
                        } == true
                    }

                    it("should compare smaller value to be falsey") {
                        expect {
                            let expression = try Phrase("2 >= 3")
                            return try expression.evaluate()
                        } == false
                    }
                }

                describe("less than") {

                    it("should fail to compare constants of different types") {
                        expect {
                            let expression = try Phrase("1 < 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should compare smaller value to be truthy") {
                        expect {
                            let expression = try Phrase("2 < 1")
                            return try expression.evaluate()
                        } == false
                    }

                    it("should compare equal value to be falsey") {
                        expect {
                            let expression = try Phrase("2 < 2")
                            return try expression.evaluate()
                        } == false
                    }

                    it("should compare smaller value to be truthy") {
                        expect {
                            let expression = try Phrase("2 < 3")
                            return try expression.evaluate()
                        } == true
                    }
                }

                describe("less than or equal") {

                    it("should fail to compare constants of different types") {
                        expect {
                            let expression = try Phrase("1 <= 'some text'")
                            _ = try expression.evaluate()
                        }.to(throwError(PhraseError.typesMismatch))
                    }

                    it("should compare smaller value to be truthy") {
                        expect {
                            let expression = try Phrase("2 <= 1")
                            return try expression.evaluate()
                        } == false
                    }

                    it("should compare equal value to be falsey") {
                        expect {
                            let expression = try Phrase("2 <= 2")
                            return try expression.evaluate()
                        } == true
                    }

                    it("should compare smaller value to be truthy") {
                        expect {
                            let expression = try Phrase("2 <= 3")
                            return try expression.evaluate()
                        } == true
                    }
                }
            }

            describe("variable resolving") {

                it("should return false if variable is missing") {
                    expect {
                        let expression = try Phrase("a == b")
                        expression.context = [
                            "a": 1
                        ]
                        return try expression.evaluate()
                    } == false
                }

                it("should resolve string variables") {
                    expect {
                        let expression = try Phrase("a == 'text'")
                        expression.context = [
                            "a": "text"
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == 'text'")
                        expression.context = [
                            "a": "text"
                        ]
                        return try expression.evaluate()
                    } == true
                }

                it("should resolve integer variables") {
                    expect {
                        let expression = try Phrase("a == 2")
                        expression.context = [
                            "a": 2
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == 3")
                        expression.context = [
                            "a": 2
                        ]
                        return try expression.evaluate()
                    } == false
                }

                it("should resolve float variables") {
                    expect {
                        let expression = try Phrase("a == 1.2345679")
                        expression.context = [
                            "a": Float(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == 0")
                        expression.context = [
                            "a": Float(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == false
                }

                it("should resolve double variables") {
                    expect {
                        let expression = try Phrase("a == 1.23456789")
                        expression.context = [
                            "a": Double(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == 0")
                        expression.context = [
                            "a": Double(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == false
                }

                it("should resolve double variables") {
                    expect {
                        let expression = try Phrase("a == 1.23456789")
                        expression.context = [
                            "a": Double(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == 0")
                        expression.context = [
                            "a": Double(1.23456789)
                        ]
                        return try expression.evaluate()
                    } == false
                }

                it("should resolve array variables") {
                    expect {
                        let expression = try Phrase("a == [1,2,3]")
                        expression.context = [
                            "a": [1, 2, 3]
                        ]
                        return try expression.evaluate()
                    } == true

                    expect {
                        let expression = try Phrase("a == []")
                        expression.context = [
                            "a": [1, 2, 3]
                        ]
                        return try expression.evaluate()
                    } == false
                }
            }

            describe("postfix method count") {

                it("should fail if type is not array") {
                    expect {
                        let expression = try Phrase("a.count == 3")
                        expression.context = [
                            "a": 1
                        ]
                        _ = try expression.evaluate()
                    }.to(throwError(PhraseError.typesMismatch))
                }

                it("should return correct array length") {
                    expect {
                        let expression = try Phrase("a.count == 3")
                        expression.context = [
                            "a": [1, 2, 3]
                        ]
                        return try expression.evaluate()
                    } == true
                }
            }

            describe("complex expression") {

                it("should return correct for null-check and size") {
                    expect {
                        let expression = try Phrase("a != nil && a.count == 3")
                        expression.context = [
                            "a": [1, 2, 3]
                        ]
                        return try expression.evaluate()
                    } == true
                }
            }
        }
    }
}
