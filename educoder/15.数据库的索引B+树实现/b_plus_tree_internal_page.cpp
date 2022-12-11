#include <iostream>
#include <sstream>

#include "common/exception.h"
#include "storage/page/b_plus_tree_internal_page.h"
/*
 *�ڲ����ʵ��˵����
 *    ���ļ���Ҫʵ���ڲ����ĳ�ʼ�������ҡ����ѣ��ϲ��Լ��ط����
 *  �㷨����Ϊ�ڲ����ı䶯�����ѣ��ϲ��Լ��ط��䣩�����������
 *  �������Щ�㷨�У�Ҫ�ر�ע��this���ĸ��ڵ�����á�
 */

namespace bustub {
/*
 * �������ܣ�
 *  ��ʼ��thisҳ������page type,size,page id,parent id and max page size
 *  ���룺
 *    page_id_t page_id ҳ��
 *    page_id_t parent_id ��ҳ��
 *    int max_size ҳԪ�����ֵ
 *  ��ʾ����Ϊ���ڲ�ҳ�࣬���ҳ����Ӧ������ΪIndexPageType::INTERNAL_PAGE
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::Init(page_id_t page_id, page_id_t parent_id, int max_size) {
  SetPageType(IndexPageType::INTERNAL_PAGE);
  SetSize(0);
  SetPageId(page_id);
  SetParentPageId(parent_id);
  SetMaxSize(max_size);
}

/*
 * �������ܣ�
 *  ����index����keyֵ
 * ���飺
 *   1.leafҳ������Ԫ��Ϊpair��firstΪkey��secondΪRID
 *   2.internalҳ������Ԫ��Ϊpair��firstΪkey��secondΪPAGE_ID
 */
INDEX_TEMPLATE_ARGUMENTS
KeyType B_PLUS_TREE_INTERNAL_PAGE_TYPE::KeyAt(int index) const {
  return array_[index].first;
}
/*
 * �������ܣ�
 *  ����index����keyֵ
 * ���飺
 *   
 *   1.internal������Ԫ��Ϊpair��firstΪkey��secondΪPAGE_ID
 */

INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::SetKeyAt(int index, const KeyType &key) { 
	array_[index].first=key;
  return ;
}

/*
 * �������ܣ�
 *  Ѱ�ҵ�ǰ������еļ�ֵ��key������ֵΪvalue��Ԫ�ص�����
 * ���飺
 *  1.���δ�ҵ�������-1
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_INTERNAL_PAGE_TYPE::ValueIndex(const ValueType &value) const {
  for(int i=0;i<GetSize();i++)
  {
      if(array_[i].second==value)
        return i;
  }
  return -1;
}
/*
 * �������ܣ�
 *  ��������index����value
 *
 */
INDEX_TEMPLATE_ARGUMENTS
ValueType B_PLUS_TREE_INTERNAL_PAGE_TYPE::ValueAt(int index) const {
  return array_[index].second;
}

/*****************************************************************************
 * ����
 *****************************************************************************/
/*
 * �������ܣ�
 *  ��keyֵ�������е������У��ҵ��ض�keyֵ��Ӧ��value
 * ���飺
 *  1.ѡ����ʲ��ҷ�
 *  2.���keyֵ�����ڣ�������ӽ��Ľ�Сkey��Ӧ��value
 *  3.ʹ��comparator����keyֵ�ıȽ�
 */
INDEX_TEMPLATE_ARGUMENTS
ValueType B_PLUS_TREE_INTERNAL_PAGE_TYPE::Lookup(const KeyType &key, const KeyComparator &comparator) const {
  assert(GetSize() > 1);
  int left=0;
  int right=GetSize()-1;
  int mid;
  while(left<=right)
  {
    mid=(right+left)>>1;
    if(comparator(array_[mid].first,key)<0)
      left=mid+1;
    else if(comparator(array_[mid].first,key)>0)
      right=mid-1;
    else return array_[mid].second;

  }
  return array_[right].second;

}

/*****************************************************************************
 * �ڲ�������
 *****************************************************************************/
/* ʹ�ó���
 *  ���������Ԫ�ع���ʱ�����ڷ��Ѻ�ԭ���ĸ��ڵ���Ϊ�ڲ���㣬ͬʱҪ�����µĸ��ڵ�
 *  ���´����ĸ��ڵ���Ҫ��ʼ��
 * �������ܣ�
 *  ���µĸ������г�ʼ�����
 * ���飺
 *  1.�ú�������InsertIntoParent()(b_plus_tree.cpp)�е���
 *  2.��ʼ����������Ԫ��Ϊ[<invalid, old_value>, <new_key, new_value>]
 *  3.���ڵ����ʱ�����ѵ�new_Key��Ҫͨ������InsertIntoParent()���뵽���ڵ��У�
 *    �����ǰ�ڵ�Ϊ���ڵ㣬��ô��Ҫ�����µĸ��ڵ㣬��ͨ��PopulateNewRoot������ʼ����
 *  4.����size=2
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::PopulateNewRoot(const ValueType &old_value, const KeyType &new_key,
                                                     const ValueType &new_value) {
  //�ú���Ϊ���ڵײ�䶯�����µĸ�Ԫ�أ���ʱ�Ըø�Ԫ�ؽ�������
  // array_[0]={IndexPageType::INVALID_INDEX_PAGE,old_value};//keytype��ɶ
  array_[1]={new_key,new_value};
  array_[0].second = old_value;
  SetSize(2);

}
/* ʹ�ó�����
 *  B+���Ĳ��룺��B+�������ѣ��ᴴ��һ���µ�split��㣬ͨ������InsertIntoParent����
 *  ���µ�split�����뵽���ڵ㣬��InsertIntoParent��������Ҫ����InsertNodeAfter����
 *  ���롣
 * �������ܣ�
 *  �ڵ�ǰpage���ҵ�old_value��λ�ã�Ȼ��new_key��new_value��������
 * ���飺
 *  1.��ֵ�����������Լ����ӹ�ϵ�˴����账�������������ⲿ����
 *  2.���old_value�����ڣ�����-1
 *  3.return size 
 * �����߼����飺
 *  1.ͨ��old_value�ҵ�old_value���ڵ�����λ��old_index
 *  2.���old_index=-1,��������-1
 *  3.���old_index<>-1����ô��old_index֮���Ԫ��(����old_index)����ƶ�һλ
 *  4.��old_index���µļ�ֵ�Բ������
 */
INDEX_TEMPLATE_ARGUMENTS
int B_PLUS_TREE_INTERNAL_PAGE_TYPE::InsertNodeAfter(const ValueType &old_value, const KeyType &new_key,
                                                    const ValueType &new_value) {
  //���ײ�Ԫ�ط��Ѻ���Ҫ�ڸ��ڵ�ĵ�ǰ�ײ�Ԫ��������old_value��������½ڵ�ָ����Ѻ���µײ�ڵ�
  int old_index=ValueIndex(old_value);
  if(old_index==-1)
    return -1;
  for(int i=GetSize();i>=old_index+2;i--)
  {
    array_[i]=array_[i-1];
  }
  array_[old_index+1]={new_key,new_value};
  IncreaseSize(1);
  return GetSize();
}

/*****************************************************************************
 * �ڲ�������
 *****************************************************************************/
/*
 *�������ܣ�
 * �ƶ�this�����һ�루����ȡ������Ԫ�ص�һ�������ɵ�recipient�����
 *���飺
 *  1.����ʵ��CopyNFrom����
 *  2.���ڲ�����CopyNFrom����ʵ�ָù���
 *  3.һ�����ڵ�ǰ�����Ԫ�����ʱ���з��ѣ�������Ԫ�������½���С������ں����ⲿ���и����Ԫ�صĸ��£�
 *  eg:
 *    this == r1,  recipient == r2
 *    r1->[<invalid, p0>, <1, p1>, <2, p2>, <3, p3>, <4, p4>] ----MoveHalfTo--> r2[]
 *    result: r1->[<invalid, p0>, <1, p1>],r2[<2, p2>, <3, p3>, <4, p4>]
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::MoveHalfTo(BPlusTreeInternalPage *recipient,
                                                BufferPoolManager *buffer_pool_manager) {
  int size=GetSize();
  int move_size=(size+1)>>1;
  recipient->CopyNFrom(array_+size/2,move_size,buffer_pool_manager);
  SetSize(size-move_size);
  return ;
}

/*
 * �������ܣ�
 *  ��item����ʼ����ȡsize����ֵ�Բ��뵽����β��
 * ���飺
 *  1.���ڸý�������ڲ���㣬�����Ԫ��Ǩ�ƺ���Ҫ����Ԫ�ص�ParentPageId���и��£������ӽ�����fetch�����º���unpin
 *  2.����size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::CopyNFrom(MappingType *items, int size, BufferPoolManager *buffer_pool_manager) {
	//�ڲ��ڵ������ָ������Ԫ�ؽ�㣬��Ǩ�ƺ������ϵ�Բ���
  //���������ڲ��ڵ�һ����Ǩ�Ƶ����µĽ�㣬���ⲿ�ֵ���Ԫ�ؽ��ĸ�Ԫ����Ҫ����
  //����Ҫ��page�Ӵ�����ȡ������bufferpool
  //���̣�
  //��array_[i].second(Page_id)����Ӧ��ҳȡ������������ָ��page
  //Page *page = buffer_pool_manager->FetchPage(array_[i].second);
  // page->GetData()ǿתΪBPlusTreePage
  //  BPlusTreePage *bp_tree_page = reinterpret_cast<BPlusTreePage *>(page->GetData());
  // bp_tree_page�ĸ��������Ϊ���ڵ�
  // bp_tree_page->SetParentPageId(GetPageId());
  // ������Ϻ���unpin
  // buffer_pool_manager->UnpinPage(array_[i].second, true);
  MappingType* temp=items;
  for(int i=GetSize()+0;i<GetSize()+size;i++)
  {
      array_[i]=*temp;
      Page* page=buffer_pool_manager->FetchPage(array_[i].second);                     //ȡ��array_[i]��page                                              
      BPlusTreePage *bp_tree_page = reinterpret_cast<BPlusTreePage *>(page->GetData());//ǿתΪBPlusTreePage
      bp_tree_page->SetParentPageId(GetPageId());                                      //����bp_tree_page�ĸ��ڵ�
      buffer_pool_manager->UnpinPage(array_[i].second, true);   
      temp++;
  }
  IncreaseSize(size);
    
}

/*****************************************************************************
 * �ڲ�����Ƴ�
 *****************************************************************************/
/*
 * �������ܣ�
 *  1.�Ƴ�this����е�index���ļ�ֵ��
 * ���飺
 *  1.ע��Ԫ�ص��ƶ�
 *  2.����size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::Remove(int index) 
{

  int size=GetSize();
  for(int i=index;i<size-1;i++)
  {
    array_[i]=array_[i+1];
  }
  IncreaseSize(-1);
  return ;
}

/* ʹ���龰��
 *  �����ڵ�ֻ��һ���ӽڵ�ʱ�����Խ�������ڵ�ɾ�����������ӽڵ�����������Ϊ���ڵ�
 * �������ܣ�
 *  ���ظ���㺬�е�ΨһԪ��ValueAt(0)
 * ���飺
 *  1.�ú���ֻ��AdjustRoot()(in b_plus_tree.cpp)�е���
 *  2.����size
 */ 
INDEX_TEMPLATE_ARGUMENTS
ValueType B_PLUS_TREE_INTERNAL_PAGE_TYPE::RemoveAndReturnOnlyChild() 
{ 
  IncreaseSize(-1);//???
  return ValueAt(0);
}
/*****************************************************************************
 * �ڲ����ϲ�
 *****************************************************************************/
/*ʹ�ó�����
 *  ��ǰ�ڵ�ɾ�� key �󣬽ڵ������С�� MinSize, ��� sibling size ���ٵ�����£�
 *  ���˽����ط��䣬�����ֵܽڵ�� size ��С��MinSize����ʱӦ���Ǻϲ������ֵܽڵ�� 
 *  size û�е������ֵʱ����ǰ�ڵ��ʣ���ֵ�Կ��Ժϲ���ýڵ㡣
 *�������ܣ�
 *  �ϲ�this����Ԫ����recipient����У�����this����е�ȫ��Ԫ������recipient����β��
 *���飺
 *  1.this���ı仯Ӱ�������ӽ�㣨�ӽ��ĸ����������Ҫ���и��£�
 *  2.����recipient����size��С
 *  3.this���ı仯Ӱ�����丸��㣨�������ָ��ý��ļ�ֵ����Ҫ�������,�˲����ں�������У�
 *    ����Ҫ�ڴ˴�ʵ��
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::MoveAllTo(BPlusTreeInternalPage *recipient,
                                               BufferPoolManager *buffer_pool_manager) 
{


  // the separation key from parent
	//the separation key��valueָ��this��㣬��this�����Ԫ�ص�ֵ������the separation key
	//this������Ԫ����keyֵ���޷�ֱ�Ӻϲ���recipient����Ԫ����ָ���ֵ��the separation key���һ��Ԫ��С������Ԫ�ص�keyʵ���Ͼ���the separation key��
  
  int this_size=GetSize();
  int start_index_in_recipient=recipient->GetSize();

  page_id_t recipent_page_id=recipient->GetPageId();                /*����this���ӽ��ĸ��ڵ�*/
  for(int i=0;i<this_size;i++)
  {
    Page* page=buffer_pool_manager->FetchPage(array_[i].second);                      //ȡ��array_[i]��page   
    BPlusTreePage *bp_tree_page = reinterpret_cast<BPlusTreePage *>(page->GetData()); //ǿתΪBPlusTreePage
    bp_tree_page->SetParentPageId(recipent_page_id);                                       //����bp_tree_page�ĸ��ڵ�
    buffer_pool_manager->UnpinPage(array_[i].second, true);   
  }

  for(int i=0;i<this_size;i++)                            /*����recipient��array_*/
  {
      recipient->array_[start_index_in_recipient+i]=array_[i];
  }
  recipient->IncreaseSize(this_size);                     /*update size of recipient node*/

}



/*
 * �������ܣ�
 *  ��pairԪ����ӵ�this����β��
 * ���飺
 *  1.����pairԪ�صĸ������ϢΪthis����PageId
 *  2.����size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::CopyLastFrom(const MappingType &pair, BufferPoolManager *buffer_pool_manager) 
{
	/*����pairԪ�صĸ��ڵ�*/
	Page* page=buffer_pool_manager->FetchPage(pair.second);                      			//ȡ��pair��page   
	BPlusTreePage *bp_tree_page = reinterpret_cast<BPlusTreePage *>(page->GetData()); 		//ǿתΪBPlusTreePage
	bp_tree_page->SetParentPageId(GetPageId());                                       		//���ø��ڵ�
	buffer_pool_manager->UnpinPage(pair.second, true);
	/*����this���*/
	array_[GetSize()]=pair;
	IncreaseSize(1);
	return ;
}

/*****************************************************************************
 * �ط���
 *****************************************************************************/
/*ʹ�ó�����
 *  ��ǰ�ڵ�ɾ�� key �󣬽ڵ������С�� MinSize,����� sibling size ����������£�
 *  ���˽���merge�������ֵܽ� ��� size ���������ʱӦ�����ط��䡣������sibling���
 *  ����Ԫ���Ƶ����ڵ㣬�����ط��䡣
 *
 * �������ܣ�
 *  �ƶ�this������Ԫ����recipient����ĩβ
 * ���飺
 *  1.recipient����CopyLastFrom����ʵ�ֽڵ����
 *  2.this������size
 *  3.����this�����Ԫ�ر仯����˸������this����������Ҫ����
 */

INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::MoveFirstToEndOf(BPlusTreeInternalPage *recipient,
                                                      BufferPoolManager *buffer_pool_manager) {

	/*��this������Ԫ������recipient�Ľ�β*/
	recipient->CopyLastFrom(array_[0], buffer_pool_manager);

	/*����this���*/
	IncreaseSize(-1);
	for(int i=0;i<GetSize();i++)
		array_[i]=array_[i+1];

	/*����this���ĸ����*/
	Page *page = buffer_pool_manager->FetchPage(GetParentPageId());
	BPlusTreeInternalPage *parent = reinterpret_cast<BPlusTreeInternalPage *>(page->GetData());
	

	parent->SetKeyAt(parent->ValueIndex(GetPageId()), array_[0].first);
	buffer_pool_manager->UnpinPage(GetParentPageId(), true);
	return;

}

/*
 * �������ܣ�
 *  �ƶ�this����β��Ԫ����recipient����ͷ��
 * ���飺
 *  1.recipient����CopyFirstFrom����ʵ�ֽڵ����
 *  2.this������size
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::MoveLastToFrontOf(BPlusTreeInternalPage *recipient,
                                                       BufferPoolManager *buffer_pool_manager) {
	/*�ƶ�this����β��Ԫ�ص�recipient��ͷ��*/
	MappingType pair{KeyAt(GetSize() - 1), ValueAt(GetSize() - 1)};
	/*����this���*/
	IncreaseSize(-1);
	recipient->CopyFirstFrom(pair,buffer_pool_manager);
	
	
}

/*
 * �������ܣ�
 *  �ƶ�pairԪ����this�����ײ�
 * ���飺
 *  1.������Ԫ�ر仯����Ҫ�Ը�����е��������и���
 *  2.����size
 *  3.����pairԪ�صĸ������Ϣ
 */
INDEX_TEMPLATE_ARGUMENTS
void B_PLUS_TREE_INTERNAL_PAGE_TYPE::CopyFirstFrom(const MappingType &pair, BufferPoolManager *buffer_pool_manager) {
  	/*����this���ĸ����*/
	Page* page=buffer_pool_manager->FetchPage(GetParentPageId());                     						/*ȡ��this���ĸ����*/
	BPlusTreePage *parent = reinterpret_cast<BPlusTreePage *>(page->GetData()); 		    				/*ǿתΪBPlusTreePage*/				                    
	parent->SetKeyAt(parent->ValueIndex(GetPageId()),pair.first);																/*���¸���������*/
  	buffer_pool_manager->UnpinPage(GetParentPageId(),true);

	/*����this����array_*/
	IncreaseSize(1);
	for(int i=GetSize();i>=1;i--)
		array_[i]=array_[i-1];
	array_[0]=pair;

	/*����pairԪ�صĸ��ڵ�*/
	page=buffer_pool_manager->FetchPage(pair.second);                      				//ȡ��pair��page   
	BPlusTreePage pair_node = reinterpret_cast<BPlusTreePage *>(page->GetData()); 						//ǿתΪBPlusTreePage
	pair_node->SetParentPageId(GetPageId());                                       		//����pair�ĸ��ڵ�Ϊthis���
	buffer_pool_manager->UnpinPage(pair.second, true);


	

}


template class BPlusTreeInternalPage<GenericKey<4>, page_id_t, GenericComparator<4>>;
template class BPlusTreeInternalPage<GenericKey<8>, page_id_t, GenericComparator<8>>;
template class BPlusTreeInternalPage<GenericKey<16>, page_id_t, GenericComparator<16>>;
template class BPlusTreeInternalPage<GenericKey<32>, page_id_t, GenericComparator<32>>;
template class BPlusTreeInternalPage<GenericKey<64>, page_id_t, GenericComparator<64>>;
}
