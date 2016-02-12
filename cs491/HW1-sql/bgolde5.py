import sqlite3

####################################################
# assign [your netid].result to netid variable
####################################################
netid = "bgolde5.result"  # suppose your netid is "liu4", the output file should be
                       # liu4.result with extension .result

###########################################
# put database file in the right path
###########################################
social_db = "./data/social.db"
matrix_db = "./data/matrix.db"
university_db = "./data/university.db"

#################################
# write all your query here
#################################
# completed_queries = 6

query_1 = """
            select name
            from Student
            where grade=9
            order by name asc;
            """

query_2 = """
            select grade, count(*)
            from Student
            group by grade
            order by grade asc;
            """

query_3 = """
            select Student.name, Student.grade from Student 
	    where (select count(Friend.ID1) > 2 from Friend
	    where Student.ID = Friend.ID1)
	    order by name asc, grade asc;
            """

query_4 = """
	    select Student.name, Student.grade from Student, Likes
	    -- students are liked by someone
	    where Likes.ID2 = Student.ID
	     -- grade of the student liked is less than the student who likes them
	     and Student.grade < (select Student.grade from Student where Likes.ID1 = Student.ID)
	     order by name asc, grade asc;
            """

query_5 = """
            -- students that like someone also have the same friend
            select distinct name, grade from Friend, Likes, Student where (Student.ID = Likes.ID1 and Student.ID = Friend.ID1
            and Likes.ID2 = Friend.ID2)

            union

            -- students don't like anyone
            select distinct name, grade From Student
            where not exists (select * from Likes where Student.ID = Likes.ID1)

            order by name asc, grade asc;
            """

query_6 = """
	    -- student a likes b
	    select distinct StudentA.ID as ID1, StudentA.name, StudentB.ID as ID2, StudentB.name 
	    from Student as StudentA, Student as StudentB, Likes
	    where StudentA.ID = Likes.ID1 and StudentB.ID = Likes.ID2

	    except 

	    -- student a is friends with student b
	    select distinct StudentA.ID as ID1, StudentA.name, StudentB.ID as ID2, StudentB.name 
	    from Student as StudentA, Student as StudentB, Friend
	    where StudentA.ID = Friend.ID1 and StudentB.ID = Friend.ID2

	    order by ID1 asc, ID2 asc;
	    """

query_7 = None
query_8 = None

## problem 2
query_9 = """
	    select distinct tenured, avg(class_score) from Fact_Course_Evaluation, Dim_Professor
	    where tenured = 0 and Fact_Course_Evaluation.professor_id = Dim_Professor.id

	    union

	    select distinct tenured, avg(class_score) from Fact_Course_Evaluation, Dim_Professor
	    where tenured = 1 and Fact_Course_Evaluation.professor_id = Dim_Professor.id

	    order by tenured asc;
	    """

query_10 = """
            select year, area, avg(class_score) as avg_score from Fact_Course_Evaluation, Dim_Term, Dim_Type
            -- match all ids
            where Fact_Course_Evaluation.type_id = Dim_Type.id
            and Fact_Course_Evaluation.term_id = Dim_Term.id
            group by area, year
            order by year asc, area asc;
            """

## problem 3
query_11 = """
            -- clean up the results for display
            select a_row as row_num, b_col as col_num, product 
            -- get A x B
            from ( select 
            -- a matrix
            a.row_num as a_row, a.col_num as a_col, a.value as a_value,  

            -- b matrix
            b.row_num as b_row,  b.col_num as b_col, b.value as b_value,

            -- sum product of a and b
            sum(a.value * b.value) as product from a,b 
            where a.col_num = b.row_num
            group by a_row, b_col)
            order by row_num asc, col_num asc;
            """

################################################################################

def get_query_list():
    """
    Form a query list for all the queries above
    """
    query_list = []
    for index in range(1, 12):
        # if eval('query_' + str(index)):
            # eval('print query_' + str(index))
        eval("query_list.append(query_" + str(index) + ")")
    # end for
    return query_list
pass

def output_result(index, result):
    """
    Output the result of query to facilitate autograding.
    Caution!! Do not change this method
    """
    with open(netid, 'a') as fout:
        fout.write("<"+str(index)+">\n")
    with open(netid, 'a') as fout:
        for item in result:
            fout.write(str(item))
            fout.write('\n')
        #end for
    #end with
    with open(netid, 'a') as fout:
        fout.write("</"+str(index) + ">\n")
    pass

def run():
    ## get all the query list
    query_list = get_query_list()

    ## problem 1
    conn = sqlite3.connect(social_db)
    cur = conn.cursor()
    for index in range(1, 7): 
        cur.execute(query_list[index-1])
        result = cur.fetchall()
        tag = "q" + str(index)
        output_result(tag, result)
    #end for

    ## problem 2
    conn = sqlite3.connect(university_db)
    cur = conn.cursor()
    for index in range(9, 11):
        cur.execute(query_list[index-1])
        result = cur.fetchall()
        tag = "q" + str(index)
        output_result(tag, result)
    # end for

    ## problem 3
    conn = sqlite3.connect(matrix_db)
    cur = conn.cursor()
    for index in range(11, 12):
        cur.execute(query_list[index-1])
        result = cur.fetchall()
        tag = "q" + str(index)
        output_result(tag, result)
    # end for
    #end run()


if __name__ == '__main__':
    run()
