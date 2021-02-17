// 数据库回滚表示
using namespace chainbase;
using namespace boost::multi_index;

struct book : public chainbase::object<0, book> {

   template<typename Constructor, typename Allocator>
    book(  Constructor&& c, Allocator&& a ) {
       c(*this);
    }

    id_type id;
    int a = 0;
    int b = 1;
};

typedef multi_index_container<
  book,
  indexed_by<
     ordered_unique< member<book,book::id_type,&book::id> >,
     ordered_non_unique< BOOST_MULTI_INDEX_MEMBER(book,int,a) >,
     ordered_non_unique< BOOST_MULTI_INDEX_MEMBER(book,int,b) >
  >,
  chainbase::allocator<book>
> book_index;

CHAINBASE_SET_INDEX_TYPE( book, book_index )

void test()
{
   boost::filesystem::path temp = "/home/shang/shangqd/eos/build/db";//boost::filesystem::unique_path();
   chainbase::database db(temp, database::read_write, 1024*1024*8);
   db.add_index< book_index >();
   const auto& new_book = db.get(book::id_type(0));
   for (int i = 0; i < 5; i++)
   {
      std::cout << db.revision() << ":" << new_book.a << "," << new_book.b << std::endl;
      db.undo();
   }
}

int main(int argc, char** argv)
{
   boost::filesystem::path temp = boost::filesystem::unique_path();
   chainbase::database db(temp, database::read_write, 1024*1024*8);
   db.add_index< book_index >();
   const auto& new_book = db.create<book>( []( book& b ) {
         b.a = 1;
         b.b = 2;
   });
   {
      db.set_revision(10);
      {
         auto s = db.start_undo_session(true);
         db.modify( new_book, [&]( book& b ) {
            b.a = 1 + 1;
            b.b = 2 + 1;
         });
         //db.commit(2);
         s.push();
      }
      {
         auto s = db.start_undo_session(true);
         db.modify( new_book, [&]( book& b ) {
            b.a = 1 + 11;
            b.b = 2 + 11;
         });
         //db.commit(11);
         s.push();
      }
      db.squash();
      db.squash();
      // 11 变成不可回滚
      db.set_revision(11);
      std::vector<database::session> vs;
      vs.push_back(db.start_undo_session(true));
      db.modify( new_book, [&]( book& b ) {
            b.a = 101;
            b.b = 101;
      });
      vs.push_back(db.start_undo_session(true));
      db.modify( new_book, [&]( book& b ) {
            b.a = 102;
            b.b = 102;
      });
      vs[1].push();
      // 这个块变成不可逆转
      //vs[0].squash();
      vs[0].push();
      vs.clear();
      std::cout << db.revision() << ":" << new_book.a << "," << new_book.b << std::endl;
      db.undo();
      std::cout << db.revision() << ":" << new_book.a << "," << new_book.b << std::endl;
      db.undo();
      std::cout << db.revision() << ":" << new_book.a << "," << new_book.b << std::endl;
      db.undo();
      std::cout << db.revision() << ":" << new_book.a << "," << new_book.b << std::endl;
   }
   return 0;
}