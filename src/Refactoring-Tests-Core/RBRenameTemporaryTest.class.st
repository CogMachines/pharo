Class {
	#name : #RBRenameTemporaryTest,
	#superclass : #RBRefactoringTest,
	#category : #'Refactoring-Tests-Core'
}

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testBadInterval [
	self shouldFail: (RBRenameTemporaryRefactoring 
			renameTemporaryFrom: (self 
					convertInterval: (14 to: 17)
					for: (RBRefactoryTestDataApp sourceCodeAt: #testMethod))
			to: 'asdf'
			in: RBRefactoryTestDataApp
			selector: #testMethod)
]

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testBadName [
	self
		shouldFail: (RBRenameTemporaryRefactoring 
				renameTemporaryFrom: (self 
						convertInterval: (15 to: 19)
						for: (RBLintRuleTestData sourceCodeAt: #openEditor))
				to: 'name'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail: (RBRenameTemporaryRefactoring 
				renameTemporaryFrom: (self 
						convertInterval: (15 to: 19)
						for: (RBLintRuleTestData sourceCodeAt: #openEditor))
				to: 'rules'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail: (RBRenameTemporaryRefactoring 
				renameTemporaryFrom: (self 
						convertInterval: (15 to: 19)
						for: (RBLintRuleTestData sourceCodeAt: #openEditor))
				to: 'DependentFields'
				in: RBLintRuleTestData
				selector: #openEditor);
		shouldFail: (RBRenameTemporaryRefactoring 
				renameTemporaryFrom: (self 
						convertInterval: (15 to: 19)
						for: (RBLintRuleTestData sourceCodeAt: #openEditor))
				to: 'a b'
				in: RBLintRuleTestData
				selector: #openEditor)
]

{ #category : #'failure tests' }
RBRenameTemporaryTest >> testModelBadName [
	| class |
	model := RBClassModelFactory rbNamespace new.
	class := model classNamed: #Object.
	class 
		compile: 'aMethod: temp1 ^[| temp2 | temp2 := [:temp3 | temp3 = 5] value: 5. temp2] value'
		classified: #(#accessing).
	self
		shouldFail: (RBRenameTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp3'
					in: class
					selector: #aMethod:);
		shouldFail: (RBRenameTemporaryRefactoring 
					renameTemporaryFrom: (20 to: 24)
					to: 'temp1'
					in: class
					selector: #aMethod:)
]

{ #category : #tests }
RBRenameTemporaryTest >> testRenameTemporary [
	| refactoring |
	refactoring := RBRenameTemporaryRefactoring 
		renameTemporaryFrom: (self 
				convertInterval: (15 to: 19)
				for: (RBLintRuleTestData sourceCodeAt: #openEditor))
		to: 'asdf'
		in: RBLintRuleTestData
		selector: #openEditor.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #RBLintRuleTestData) parseTreeFor: #openEditor) = (RBParser parseMethod: 'openEditor
								| asdf |
								asdf := self failedRules.
								asdf isEmpty ifTrue: [^self].
								asdf size == 1 ifTrue: [^asdf first viewResults]')
]
