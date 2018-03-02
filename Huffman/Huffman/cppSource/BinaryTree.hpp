//
//  Simplified Binary Tree
//  9.4
//
//  Created by Eric on 27/12/2017.
//  Copyright © 2017 Eric. All rights reserved.
//

#ifndef BinaryTree_hpp
#define BinaryTree_hpp

#include "LinkedStack.hpp"

template <typename T> class BinaryTree;

template <typename T>
class TreeNode {
    friend class BinaryTree<T>;
    TreeNode<T> * leftChild;
    TreeNode<T> * rightChild;
    T data;
public:
    TreeNode(TreeNode<T> * l, TreeNode<T> * r, const T & data):
        leftChild(l), rightChild(r), data(data) {}
    TreeNode(const T & data): data(data), leftChild(0), rightChild(0) {}
    TreeNode(): leftChild(0), rightChild(0), data(0) {}
};

template <typename T>
class BinaryTree {
    TreeNode<T> * root;
    
    void copyPreOrder(TreeNode<T> * &, const TreeNode<T> *) const;
    void deletePostOrder(TreeNode<T> * &);
    void printPreOrder(TreeNode<T> *, string & split);
    
    ///从左到右按"列"打印元素路径
    void allPath(TreeNode<T> *, LinkedStack<T> &) const;
    ///用于霍夫曼的allPath，打印每个元素的编码
    void allPath2(TreeNode<T> *, LinkedStack<int> &) const;
 
public:
 
    ///缺省构造
    BinaryTree() { root = 0; }
    ///一个元素一棵树
    BinaryTree(const T & data) {
        root = new TreeNode<T>(data);
    }
    ///复制构造 我们要把整颗树挖出来复制 而不单单是root
//    BinaryTree(const BinaryTree<T> & t) {
//        root = t.copy().root;
//        //TODO: - 修改
//    }
   
    BinaryTree<T> copy() const;
    
    //TODO: - 我们暂时不自动删除一棵树
    //~BinaryTree() { Delete(); }
    void Delete() { deletePostOrder(root); root = 0; }
    
    ///1霍夫曼0值
    void allPath(bool with01) const;///根到所有叶子结点的路径
 
    void makeTree(const T &, BinaryTree<T> &, BinaryTree<T> &);
    void breakTree(T &, BinaryTree<T> &, BinaryTree<T> &);

};

template <typename T>
BinaryTree<T> BinaryTree<T>::copy() const {
    BinaryTree<T> to;
    copyPreOrder(to.root, root);
    return to;
    //TODO: - 这里deactivate下 就可以自动析构了
}

template <typename T>
void BinaryTree<T>::allPath(bool h) const {
    if (!root) {
        cout<<endl;
        return;
    }
    if (h) {
        LinkedStack<int> s;
        allPath2(root, s);
    } else {
        LinkedStack<T> stack1;
        allPath(root, stack1);
    }
}
 
///按次序左右孩子
template <typename T>
void BinaryTree<T>::makeTree(const T & element, BinaryTree<T> & t1, BinaryTree<T> & t2) {
    if (root == t1.root)
        copyPreOrder(t1.root, root);
    if (root == t2.root)
        copyPreOrder(t2.root, root);
    if (t1.root == t2.root) {
        copyPreOrder(t1.root, t2.root);
    }
    if (root)
        Delete();
    root = new TreeNode<T>(t1.root, t2.root, element);
    t1.root = t2.root = 0;
}

template <typename T>
void BinaryTree<T>::breakTree(T & recei, BinaryTree<T> & t1, BinaryTree<T> & t2) {
    if (root == t1.root)
        t1 = BinaryTree<T>();
    if (root == t2.root)
        t2 = BinaryTree<T>();
    if (t1.root == t2.root) {
        t1 = BinaryTree<T>();
    }
    t2.Delete();
    t1.Delete();
    if (!root)
        return;
    recei = root->data;
    t1.root = root->leftChild;
    t2.root = root->rightChild;
    delete root;
    root = 0;
}


//MARK: - private functions

template <typename T>
void BinaryTree<T>::allPath(TreeNode<T>* n, LinkedStack<T>& stack) const {
    if (!n)
        return;
    stack.push(n->data);
    if (!n->leftChild && !n->rightChild) {
        T * result = stack.output(',');
        delete [] result;
    }
    else {
        allPath(n->leftChild, stack);
        allPath(n->rightChild, stack);
    }
    stack.pop();
 
}

template <typename T>
void BinaryTree<T>::allPath2(TreeNode<T> * n, LinkedStack<int>& stack) const {
    if (!n)
        return;
    if (n->leftChild) {
        stack.push(0);
        allPath2(n->leftChild, stack);
        stack.pop();
    }
    if (n->rightChild) {
        stack.push(1);
        allPath2(n->rightChild, stack);
        stack.pop();
    }
    if (!n->leftChild && !n->rightChild) {
      //  cout<<n->data<<": ";
        int * result = stack.output(',');
        delete [] result;
    }
}

//MARK: - 任务遍历
template <typename R>
void BinaryTree<R>::deletePostOrder(TreeNode<R> * & t) {
    if (!t) return;
    deletePostOrder(t->leftChild);
    deletePostOrder(t->rightChild);
    delete t;
}

template <typename T>
void BinaryTree<T>::printPreOrder(TreeNode<T> * t, string & split)  {
    if (!t)
        return;
    if (t == root)
        cout<<t->data;
    else
        cout<<split<<t->data;
    printPreOrder(t->leftChild);
    printPreOrder(t->rightChild);
}

template <typename T>
void BinaryTree<T>::copyPreOrder(TreeNode<T> * & to, const TreeNode<T> * t) const {
    if (!t)
        return;
    to = new TreeNode<T>(t->data);
    copyPreOrder(to->leftChild, t->leftChild);
    copyPreOrder(to->rightChild, t->rightChild);
}

#endif /* BinaryTree_hpp */
