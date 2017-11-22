#ifndef __DRIVER_HPP__
#define __DRIVER_HPP__ 1

#include <deque>
#include <map>
#include <string>
#define LEN 1024
//namespace lexsp{
	
	enum Node_Type { node_norm, node_value, node_id, node_opt, node_type };
	enum Value_Type   {type_int, type_char, type_double, type_string, type_void};
	union Value
	{
		int i;
		double d;
		char c;
		char* str;
	};
	class Node{ // 节点基类
		protected:
			Node *children = nullptr;
			Node *brother =  nullptr;
			Node_Type type;
		public:
			char* name;
			Node(){
				name = "";
				type = node_opt;
			}
			Node(char name) : Node(name, node_norm){ }
			Node(char* name) : Node(name, node_norm){ }
			Node(char name, Node_Type type){ 
				this->name = new char[2];
				this->name[0] = name; this->name[1] = '\0';
				this->type = node_norm;
			}
			Node(char* name, Node_Type type){ this->name = name; this->type = type; }
			static Node* createNode(int num, Node* nodes[]); // 给出一个家族
			static Node* createNode(Node* root, Node* node); // 直接给出父子俩
			void addChildren(Node* child);
			void addBrother(Node *brother);
			bool isLeaf(){ return children == nullptr; }
	};
	class ValueNode : public Node{ // 存储Value类型节点 TODO： 抽象基类
	protected:
		void *value;
	public:
		Value_Type value_type;
		//Value value;
		ValueNode(){
			Node("Value", node_value);
			this->value = nullptr;
			this->value_type = type_int;
		}
		ValueNode(void *value){
			Node("Value", node_value);
			this->value = value;
			this->value_type = type_int;
		}
		ValueNode(void *value, Value_Type value_type){
			Node("Value", node_value);
			this->value = value;
			this->value_type = value_type;
		}
	};
	class StringNode : public ValueNode{
		
	public:
		std::string value;
		StringNode(char name) :ValueNode((void*)name, type_string) {
			this->value = name;
		}
		StringNode(char* name) :ValueNode((void*)name, type_string) {
			this->value = name;
		}
	};
	class IntNode :public ValueNode{
		
	public:
		int value;
		IntNode(int value) :ValueNode((void*)value, type_int) {
			this->value = value;
		}
	};
	class DoubleNode : public ValueNode{
	public:
		double value;
		DoubleNode(char* value):ValueNode((void*)value, type_double) { // 只有double类型需要再将字符串转为浮点数
			this->value = atof(value);
		}
	};
	class CharNode : public ValueNode{
	public:
		char value;
		CharNode(char value) : ValueNode((void*)value, type_char) {
			this->value = value;
		}
	};
	class IDNode : public Node{
	public:
		IDNode(char* name):Node(name, node_id){
		}
		IDNode(char name):Node(name, node_id){
		}
	};
	
	class Symbol {
		int linenum;
		std::string name;
		Value_Type type;
		void* data;
	};
	class SymbolMap{
	public:
		Symbol* find(std::string name);
		void insert(std::string name, Symbol* symbol);
	private:
		std::map<std::string, Symbol> Map;
	};
	class SymbolTable{
	public:
		Symbol* find(std::string name);
		void push(SymbolMap& map){
			MapStack.push_back(map);
		}
		void pop(){
			MapStack.pop_back();
		}
	private:
		std::deque<SymbolMap> MapStack;
	};
//} /* end namespace CP */
#endif /* END __DRIVER_HPP__ */
